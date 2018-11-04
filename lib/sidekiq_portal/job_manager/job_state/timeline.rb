# frozen_string_literal: true

# @api private
# @since 0.1.0
class Sidekiq::Portal::JobManager::JobState::Timeline
  # @return [?]
  #
  # @api private
  # @since 0.1.0
  attr_reader :initial_time

  # @return [?]
  #
  # @api private
  # @since 0.1.0
  attr_reader :target_time

  # @param initial_time [?]
  # @param target_time [?]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(initial_time, target_time)
    @initial_time = initial_time
    @target_time  = target_time
  end

  # @return [Array<?>]
  #
  # @api private
  # @since 0.1.0
  def time_points
    # ?
  end
end
