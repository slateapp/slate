# frozen_string_literal: true

# TwilioInfosController
class TwilioInfosController < ApplicationController
  def index
    @twilioinfo = current_teacher.twilio_info if current_teacher.twilio_info
  end

  def new
    @twilioinfo = TwilioInfo.new
  end

  def create
    @twilioinfo = TwilioInfo.new twilio_info_params
    create_or_update('new', 'Twilio Information', @twilioinfo, twilio_infos_path)
  end

  def edit
    @twilioinfo = TwilioInfo.find params[:id]
  end

  def update
    @twilioinfo = TwilioInfo.find params[:id]
    @twilioinfo.assign_attributes twilio_info_params
    create_or_update('edit', 'Twilio Information', @twilioinfo, twilio_infos_path)
  end

  def destroy
    @twilioinfo = TwilioInfo.find params[:id]
    @twilioinfo.destroy
    flash[:success] = 'Twilio Information deleted successfully.'
    redirect_to twilio_infos_path
  end
end

def twilio_info_save(function)
  verb = function == 'edit' ? 'updated' : 'created'
  if @twilioinfo.save
    current_teacher.twilio_info = @twilioinfo
    flash[:success] = "Twilio Information #{verb}d successfully."
    redirect_to twilio_infos_path
  else
    @twilioinfo.errors.full_messages.each { |msg| flash[:error] = msg }
    render function
  end
end

def twilio_info_params
  params[:twilio_info].permit(:phone_number, :enabled)
end
