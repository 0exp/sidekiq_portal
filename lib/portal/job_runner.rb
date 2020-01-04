# frozen_string_literal: true

# @api private
# @since 0.1.0
class Sidekiq::Portal::JobRunner
  require_relative 'job_runner/builder'

  # @param retry_count [Integer]
  # @parma retry_on_exceptions [Array<Class<Exception>>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(retry_count, retry_on_exceptions)
    @retry_count = retry_count
    @retry_on_exceptions = retry_on_exceptions
  end

  # @param job [Sidekiq::Portal::Job]
  #
  # @api private
  # @since 0.1.0
  def run(job)
    return unless time_has_come?(job)
    actualize_internal_job_state(job)
    perform(job)
  end

  private

  # @return [Integer]
  #
  # @api private
  # @since 0.1.0
  attr_reader :retry_count

  # @return [Arrray<Class<Exception>>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :retry_on_exceptions

  # @param job [Sidekiq::Portal::Job]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def time_has_come?(job)
    job.timeline.time_has_come?
  end

  # @param job [Sidekiq::Portal::Job]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def actualize_internal_job_state(job)
    job.timeline.actualize_time!
  end

  # @param job [Sidekiq::Portal::Job]
  # @param perform_attempt [Integer]
  # @return [void]
  #
  # @raise [Exception]
  #
  # @api private
  # @since 0.1.0
  def perform(job, perform_attempt = 1)
    job.klass.perform_later
  rescue => error
    if retry_on_exceptions.include?(error.class)
      (perform_attempt == retry_count) ? raise(error) : perform(job, perform_attempt.next)
    else
      raise(error)
    end
  end
end
