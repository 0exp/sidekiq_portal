# frozen_string_literal: true

class SidekiqSchedulerMock
  # @api private
  # @sicne 0.1.0
  class JobManager
    require_relative 'job_manager/job_state'
    require_relative 'job_manager/job_state_registry'
    require_relative 'job_manager/builder'

    class << self
      # @param scheduler_config [Hash]
      # @param timezone [String]
      # @return [SidekiqSchedulerMock::JobManager]
      #
      # @api private
      # @since 0.1.0
      def build(scheduler_config:, timezone:)
        Builder.build(scheduler_config: scheduler_config, timezone: timezone)
      end
    end

    # @return [SidekiqSchedulerMock::JobManager::StateRegistry]
    #
    # @api private
    # @since 0.1.0
    attr_reader :state_registry

    # @param state_registry [SidekiqSchedulerMock::JobManager::StateRegistry]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(state_registry)
      @state_registry = state_registry
    end

    # @param job_klass [Class<ActiveJob::Base>]
    # @return [SidekiqSchedulerMock::JobManager::State]
    #
    # @api private
    # @since 0.1.0
    def state_of(job_klass)
      state_registry.state_of(job_klass)
    end

    # @param job_klass [Class<ActiveJob::Base>]
    # @return [Boolean]
    #
    # @api private
    # @sicne 0.1.0
    def schedulable?(job_klass)
      state_registry.include?(job_klass)
    end

    # @param block [Proc]
    # @return [Enumerator]
    #
    # @api private
    # @since 0.1.0
    def each_job(&block)
      block_given? ? state_registry.each_job(&block) : state_registry.each_job
    end
  end
end
