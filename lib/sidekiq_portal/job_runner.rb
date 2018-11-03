# frozen_string_literal: true

# @api private
# @since 0.1.0
class Sidekiq::Portal::JobRunner
  require_relative 'job_runner/builder'
  require_relative 'job_runner/timeline'

  class << self
    # @option retries [Integer, NilClass]
    # @return [Sidekiq::Portal::JobRunner]
    #
    # @api private
    # @since 0.1.0
    def build(retries:)
      Builder.build(retries: retries)
    end
  end

  # @return [Integer, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :retries

  # @option retries [Integer, NilClass]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(retries:)
    @retries = retries
  end

  # @param job_state [Sidekiq::Portal::JobManager::JobState]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def perform(job_state)
    return unless job_state.time_has_come?

    job_state.actualize_time!
    job_state.job_klass.perform_later
  end
end
