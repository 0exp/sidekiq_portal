# frozen_string_literal: true

# @api private
# @sicne 0.1.0
class Sidekiq::Portal::JobManager
  require_relative 'job_manager/job_state'
  require_relative 'job_manager/job_state_registry'
  require_relative 'job_manager/builder'

  class << self
    # @param scheduler_config [Hash]
    # @param timezone [String]
    # @return [Sidekiq::Portal::JobManager]
    #
    # @api private
    # @since 0.1.0
    def build(scheduler_config:, timezone:)
      Builder.build(scheduler_config: scheduler_config, timezone: timezone)
    end
  end

  # @return [Sidekiq::Portal::JobManager::StateRegistry]
  #
  # @api private
  # @since 0.1.0
  attr_reader :state_registry

  # @param state_registry [Sidekiq::Portal::JobManager::StateRegistry]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(state_registry)
    @state_registry = state_registry
  end

  # @param job_klass [Class<ActiveJob::Base>]
  # @return [Sidekiq::Portal::JobManager::State]
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
