# frozen_string_literal: true

class Sidekiq::Portal::JobRunner::Timeline
  attr_reader :initial_time
  attr_reader :target_time
  attr_reader :time_plan
  attr_reader :timezone
  attr_reader :timezoner

  def initialize(initial_time, target_time, time_plan, timezone)
    @initial_time = initial_time
    @target_time  = target_time
    @time_plan    = time_plan
    @timezone     = timezone
    @timezoner    = ActiveSupport::TimeZone[timezone]
  end

  def timepoints
    start_time = initial_time

    Array.new.tap do |points|
      while start_time <= target_time
        new_point = timezoner.at(time_plan.next_time(start_time).seconds)
        next if start_time > target_time
        points << new_point
        start_time = new_point
      end
    end
  end
end
