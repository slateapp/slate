class CohortsController < ApplicationController
  before_action :authenticate_teacher!, only: [:index, :new, :create, :edit, :update, :destroy]
  
  def index
    @user = current_teacher
    @requests = Request.for_cohort(selected_cohort || Cohort.all)
    @cohorts = cohorts_in_order
    @cohort_options = cohort_options
    if Cohort.where(selected: true).count == 2
      @cohort1 = Cohort.where(selected: true).first
      @cohort2 = Cohort.where(selected: true).second
    end
  end

  def new
    @cohort = Cohort.new
  end

  def create
    @cohort = Cohort.new cohort_params
    create_or_update('new', "Cohort", @cohort, cohorts_path)
  end

  def edit
    @cohort = Cohort.find params[:id]
  end

  def current_cohorts
    @cohorts = Cohort.where(selected: true)
  end

  def selected_cohorts
    cohort1
    cohort2
    if !cohort1.empty? && !cohort2.empty? && cohort1 != cohort2
      filter_cohorts
      flash[:success] = "You successfully selected the current cohorts"
      redirect_to cohorts_path
    else
      flash[:error] = "You need to select cohorts that are not the same before continuing"
      redirect_to cohorts_path
    end
  end

  def cohort1
    cohort1 = params[:cohort1][:id]
  end

  def cohort2
    cohort2 = params[:cohort2][:id]
  end

  def filter_cohorts
    Cohort.update_all(selected: false)
    Cohort.where(id: [cohort1, cohort2]).update_all(selected: true)
    WebsocketRails[:cohorts_updated].trigger 'selected_cohorts', params
  end

  def update
    @cohort = Cohort.find params[:id]
    @cohort.assign_attributes cohort_params
    create_or_update('edit', "Cohort", @cohort, cohorts_path)
  end

  def destroy
    @cohort = Cohort.find params[:id]
    @cohort.destroy
    redirect_to cohorts_path
  end
end

def cohort_params
  params[:cohort].permit(:month, :year)
end
