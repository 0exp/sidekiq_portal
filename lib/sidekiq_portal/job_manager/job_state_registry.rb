# frozen_string_literal: true

# @api private
# @since 0.1.0
class Sidekiq::Portal::JobManager::JobStateRegistry
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

  # @param job_state [Sidekiq::Portal::JobManager::JobState]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_state(job_state)
    state_data[job_state.job_klass] = job_state
  end

  # @param job_klass [Class<ActiveJob::Base>]
  # @return [Sidekiq::Portal::Jobs::State]
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

  # @param block [Proc]
  # @return [Enumerator]
  #
  # @api private
  # @since 0.1.0
  def each_job(&block)
    block_given? ? state_data.keys.each(&block) : state_data.keys.each
  end

  # @param block [Proc]
  # @return [Enumerator]
  #
  # @api private
  # @since 0.1.0
  def each_state(&block)
    block_given? ? state_data.values.each(&block) : state_data.values.each
  end

  # @param block [Proc]
  # @return [Enumerator]
  #
  # @api private
  # @since 0.1.0
  def each_time_point(&block)
    time_points = each_state.map(&:time_points).tap(&:flatten!).tap(&:sort!).tap(&:uniq!)
    block_given? ? time_points.each(&block) : time_points.each
  end
end
