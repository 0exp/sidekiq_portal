# frozen_string_literal: true

# @api private
# @since 0.1.0
class Sidekiq::Portal::JobRegistry
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @jobs = {}
    @lock = Sidekiq::Portal::Lock.new
  end

  # @param job [Sidekiq::Portal::Job]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register(job)
    thread_safe { jobs[job.klass] = job }
  end

  # @param job_klass [Class]
  # @return [Sidekiq::Portal::Job]
  #
  # @api private
  # @since 0.1.0
  def resolve(job_klass)
    thread_safe do
      jobs.fetch(job_klass) do
        raise(
          Sidekiq::Portal::NonScheduledJobClassError,
          "Trying to work with non-scheduled job class \"#{job_klass}\""
        )
      end
    end
  end

  # @param job_klass [Class]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def include?(job_klass)
    thread_safe { jobs.key?(job_klass) }
  end

  # @param block [Block]
  # @yield [job]
  # @yieldparam job [Sidekiq::Portal::Job]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    thread_safe do
      block_given? ? jobs.each_value(&block) : jobs.each_value
    end
  end

  private

  # @return [Hash]
  #
  # @api private
  # @since 0.1.0
  attr_reader :jobs

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.thread_safe(&block)
  end
end
