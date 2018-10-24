# frozen_string_literal: true

# @api private
# @since 0.1.0
class SidekiqSchedulerMock::JobManager::JobStateRegistry
  # @return [Concurrent::Map]
  #
  # @api private
  # @since 0.1.0
  attr_reader :state_data

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @state_data = Concurrent::Map.new
  end

  # @param job_state [SidekiqSchedulerMock::JobManager::JobState]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_state(job_state)
    state_data[job_state.job_klass] = job_state
  end

  # @param job_klass [Class<ActiveJob::Base>]
  # @return [SidekiqSchedulerMock::Jobs::State]
  #
  # @api private
  # @since 0.1.0
  def state_of(job_klass)
    state_data[job_klass]
  end

  # @param [Class<ActiveJob::Base>]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def include?(job_klass)
    state_data.key?(job_klass)
  end
end
