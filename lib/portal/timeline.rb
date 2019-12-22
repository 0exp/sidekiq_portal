# frozen_string_literal: true

# @api private
# @since 0.1.0
class Sidekiq::Portal::Timeline
  require_relative 'timeline/builder'

  # @param initial_time [Time]
  # @param timezoner [ActiveSupport::TimeZone]
  # @param time_plan [Fugit::Duration, Fugit::Cron]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(initial_time, timezoner, time_plan)
    @timezoner = timezoner
    @time_plan = time_plan
    @internal_time = initial_time
    @lock = Sidekiq::Portal::Lock.new
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def actualize_time!
    @internal_time = next_time_point
  end

  # @return [Time]
  #
  # @api private
  # @since 0.1.0
  def current_time_point
    thread_safe { timezoner.at(internal_time) }
  end

  # @return [Time]
  #
  # @api private
  # @since 0.1.0
  def next_time_point
    thread_safe { timezoner.at(time_plan.next_time(current_time_point).seconds) }
  end

  # @param target_time [Time]
  # @return [Array<Time>]
  #
  # @api private
  # @since 0.1.0
  def time_points
    thread_safe do
      start_time  = current_time_point
      target_time = global_time_point

      [].tap do |future_points|
        while start_time <= target_time
          future_point = timezoner.at(time_plan.next_time(start_time).seconds)
          next if start_time > future_point
          future_points.push(future_point)
          start_time = future_point
        end
      end
    end
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def time_has_come?
    thread_safe { global_time_point >= next_time_point }
  end

  private

  # @return [Time]
  #
  # @api private
  # @since 0.1.0
  attr_reader :internal_time

  # @return [ActiveSupport::TimeZone]
  #
  # @api private
  # @since 0.1.0
  attr_reader :timezoner

  # @return [Fugit::Duration, Fugit::Cron]
  #
  # @api private
  # @since 0.1.0
  attr_reader :time_plan

  # @return [Sidekiq::Portal::Lock]
  #
  # @api private
  # @since 0.1.0
  attr_reader :lock

  # @param block [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    lock.thread_safe(&block)
  end

  # @return [Time]
  #
  # @api private
  # @since 0.1.0
  def global_time_point
    timezoner.at(Time.current)
  end
end
