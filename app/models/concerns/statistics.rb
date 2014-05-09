module Statistics
  extend ActiveSupport::Concern
  def time_to_solve
    solved_at - created_at
  end

  def Request.get_cohort(cohort)
    cohort ? Cohort.find(cohort) : Cohort.all
  end

  def Request.total_wait_time(cohort)
    todays_requests(Time.now).solved_requests.for_cohort(cohort).inject(0){|sum, request|
      sum + request.time_to_solve
    }
  end

  def Request.todays_average_wait_time_for(cohort)
    cohort = get_cohort(cohort)
    return 0 if todays_requests(Time.now).solved_requests.for_cohort(cohort).count == 0
    (total_wait_time(cohort)/Request.todays_requests(Time.now).solved_requests.for_cohort(cohort).count)/60
  end

  def Request.first_request_time(cohort)
    (todays_requests(Time.now).for_cohort(cohort).first.created_at - 1).to_i
  end

  def Request.queue_lengths_for(cohort)
    (first_request_time(cohort)..DateTime.now.to_i).step(1.minute).map{|minute|
      minute = Time.at(minute).to_datetime
      created_requests_count_for(minute) - solved_requests_count_for(minute)
    }.compact
  end

  def Request.todays_average_queue_for(cohort)
    cohort = get_cohort(cohort)
    return 0 if todays_requests(Time.now).for_cohort(cohort).count == 0
    return 0 if queue_lengths_for(cohort).count == 0
    queue_lengths_for(cohort).inject{|sum,length| sum + length}/queue_lengths_for(cohort).count
  end

  def Request.weekly_request_categories_for(cohort)
    cohort = get_cohort(cohort)
    this_weeks_requests.for_cohort(cohort).map{|request|
      [request.category.name, Request.this_weeks_requests.categorised_by(request.category).count]
    }.uniq.compact
  end

  def Request.leaderboard_for(cohort)
    cohort = get_cohort(cohort)
    this_weeks_requests.for_cohort(cohort).map{|request|
      [request.teacher.name, Request.this_weeks_requests.solved_by(request.teacher).count] if request.solved
    }.uniq.compact
  end

  def Request.weekly_issues_average_over_day_for(cohort)
    cohort = get_cohort(cohort)
    [{name: "Average Time to Solve", data: this_weeks_requests.for_cohort(cohort).solved_requests.group_by_hour(:solved_at).count},
    {name: "Average Queue", data: this_weeks_requests.for_cohort(cohort).group_by_hour(:created_at).count}]
  end
end