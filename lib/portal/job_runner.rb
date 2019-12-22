# frozen_string_literal: true

# @api private
# @since 0.1.0
class Sidekiq::Portal::JobRunner
  require_relative 'job_runner/builder'

  # @param job [Sidekiq::Portal::Job]
  #
  # @api private
  # @since 0.1.0
  def run(job)
    return unless job.timeline.time_has_come?

    job.timeline.actualize_time!
    job.klass.perform_later
  end
end
