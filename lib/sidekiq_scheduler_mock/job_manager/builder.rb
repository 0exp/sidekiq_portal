# frozen_string_literal: true

class SidekiqSchedulerMock
  # @api private
  # @since 0.1.0
  class JobManager::Builder
    class << self
      # @option scheduler_config [Hash]
      # @option timezone [String]
      # @return [SidekiqSchedulerMock::JobManager]
      #
      # @raise [SidekiqSchedulerMock::JobConfigNotFoundError]
      # @raise [SidekiqSchedulerMock::TimeConfigNotFoundError]
      #
      # @api private
      # @since 0.1.0
      def build(scheduler_config:, timezone:) # rubocop:disable Metrics/AbcSize
        current_time   = ActiveSupport::TimeZone[timezone].at(Time.current)
        state_registry = JobManager::JobStateRegistry.new

        scheduler_config.each_pair do |series_name, options|
          job_klass = options['class'].constantize rescue nil
          job_klass ||= series_name.constantize rescue nil

          raise JobConfigNotFoundError if job_klass.blank?

          cron  = options['cron']
          every = options['every']

          raise TimeConfigNotFoundError if cron.blank? || every.blank?

          job_state = JobManager::JobState.new(
            job_klass: job_klass,
            time:      current_time,
            cron:      cron,
            every:     every,
            timezone:  timezone
          )

          state_registry.add_state(job_state)
        end

        JobManager.new(state_registry)
      end
    end
  end
end
