# frozen_string_literal: true

module Sidekiq::Portal::JobManager::JobState::Timeline
  class << self
    # @param initial_time [Time]
    # @param target_time [Time]
    # @param time_plan [Fugit::Duration, Fugit::Cron]
    # @param timezoner [ActiveSupport::TimeZone]
    # @return [Array<Time>]
    #
    # @api private
    # @since 0.1.0
    def time_points(initial_time, target_time, time_plan, timezoner)
      start_time = initial_time

      [].tap do |points|
        while start_time <= target_time
          point = timezoner.at(time_plan.next_time(start_time).seconds)
          next if start_time > target_time
          points << point
          start_time = point
        end
      end
    end
  end
end
