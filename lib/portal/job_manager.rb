# frozen_string_literal: true

# @api private
# @since 0.1.0
class Sidekiq::Portal::JobManager
  require_relative 'job_manager/builder'

  # @param job_registry [Sidekiq::Portal::JobRegistry]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(job_registry)
    @job_registry = job_registry
  end

  # @param job_klass [Class]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def runnable?(job_klass)
    job_registry.include?(job_klass)
  end

  # @return [Sidekiq::Portal::Job]
  #
  # @api private
  # @since 0.1.0
  def resolve(job_klass)
    job_registry.resolve(job_klass)
  end

  # @param block [Block]
  # @yield [job]
  # @yieldparam job [Sidekiq::Portal::Job]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each_job(&block)
    block_given? ? job_registry.each(&block) : job_registry.each
  end

  # @return [Array<Time>]
  #
  # @api private
  # @since 0.1.0
  def time_points
    each_job
      .map(&:timeline)
      .map!(&:time_points)
      .tap(&:flatten!)
      .tap(&:sort!)
      .tap(&:uniq!)
      .tap { |points| points.select! { |point| point <= Time.current } }
  end

  # @param end_time [Time]
  # @param block [Block]
  # @yield time
  # @yieldparam time [Time]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each_time_point(&block)
    block_given? ? time_points.each(&block) : time_points.each
  end

  private

  # @return [Sidekiq::Portal::JobRegistry]
  #
  # @api private
  # @since 0.1.0
  attr_reader :job_registry
end
