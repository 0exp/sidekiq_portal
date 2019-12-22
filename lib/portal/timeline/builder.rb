# frozen_string_literal: true

# @api private
# @since 0.1.0
module Sidekiq::Portal::Timeline::Builder
  class << self
    # @param initial_time [Time]
    # @param cron_pattern [String, NilClass]
    # @param every_pattern [String, NilClass]
    # @param timezone [String]
    # @return [Sidekiq::Portal::Timeline]
    #
    # @api private
    # @since 0.1.0
    def build(initial_time, cron_pattern, every_pattern, timezone)
      time_plan = Fugit.parse(cron_pattern) if cron_pattern
      time_plan = Fugit.parse(every_pattern) if every_pattern
      timezoner = ActiveSupport::TimeZone[timezone]

      Sidekiq::Portal::Timeline.new(initial_time, timezoner, time_plan)
    end
  end
end
