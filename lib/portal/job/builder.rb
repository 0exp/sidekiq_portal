# frozen_string_literal: true

# @api private
# @since 0.1.0
module Sidekiq::Portal::Job::Builder
  class << self
    # @option klass [Class]
    # @option initial_time [Time]
    # @option cron_pattern [String, NilClass]
    # @option every_pattern [String, NilClass]
    # @option timezone [String]
    # @return [Sidekiq::Portal::Job]
    #
    # @api private
    # @sine 0.1.0
    def build(klass, initial_time:, cron_pattern:, every_pattern:, timezone:)
      timeline = Sidekiq::Portal::Timeline::Builder.build(
        initial_time,
        cron_pattern,
        every_pattern,
        timezone
      )

      Sidekiq::Portal::Job.new(klass, timeline)
    end
  end
end
