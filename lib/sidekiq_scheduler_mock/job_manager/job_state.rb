# frozen_string_literal: true

# @api private
# @since 0.1.0
class SidekiqSchedulerMock::JobManager::JobState
  # @return [Class<ActiveJob::Base>]
  #
  # @api private
  # @sicne 0.1.0
  attr_reader :job_klass

  # @return [Time]
  #
  # @api private
  # @since 0.1.0
  attr_reader :time

  # @return [String, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :cron

  # @return [Fugit::Cron, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :cron_time_plan

  # @return [String, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :every

  # @return [Fugit::Duration, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :every_time_plan

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :timezone

  # @return [ActiveSupport::TimeZone]
  #
  # @api private
  # @since 0.1.0
  attr_reader :timezoner

  # @option job_klass [Class<ActiveJob::Base>]
  # @option time [Time]
  # @option cron [String, NilClass]
  # @option every [String, NilClass]
  # @optiom timezone [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(job_klass:, time:, cron: nil, every: nil, timezone:)
    @job_klass = job_klass
    @time      = time
    @cron      = cron
    @every     = every
    @timezone  = timezone
    @timezoner = ActiveSupport::TimeZone[timezone]

    @cron_time_plan  = Fugit.parse(cron)  if cron
    @every_time_plan = Fugit.parse(every) if every
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def actualize_time!
    @time = next_time
  end

  # @return [Fugit::Duration, Fugit::Cron]
  #
  # @api private
  # @since 0.1.0
  def time_plan
    cron_time_plan || every_time_plan
  end

  # @return [Time]
  #
  # @api private
  # @since 0.1.0
  def current_time
    timezoner.at(Time.current)
  end

  # @return [Time]
  #
  # @api private
  # @since 0.1.0
  def last_time
    timezoner.at(time)
  end

  # @return [Time]
  #
  # @api private
  # @since 0.1.0
  def next_time
    timezoner.at(time_plan.next_time(last_time))
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def time_has_come?
    current_time >= next_time
  end
end
