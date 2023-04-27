# frozen_string_literal: true

# @api private
# @since 0.1.0
# @version 0.3.2
class Sidekiq::Portal::JobManager::Builder
  class << self
    # @param config [Sidekiq::Portal::Config]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def build(config)
      new(config).build
    end
  end

  # @param config [Sidekiq::Portal::Config]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(config)
    @scheduled_jobs_config = config.settings.scheduler_config
    @timezone = config.settings.default_timezone
  end

  # @return [Sidekiq::Portal::Manager]
  #
  # @api private
  # @since 0.1.0
  def build
    current_time = ActiveSupport::TimeZone[timezone].at(Time.current)
    job_registry = Sidekiq::Portal::JobRegistry.new

    scheduled_jobs_config.each_pair do |job_config_series, scheduler_options|
      job_klass = resolve_job_klass(job_config_series, scheduler_options)
      cron_pattern, every_pattern = resolve_time_configuration(job_klass, scheduler_options)
      job_wrapper = build_job_wrapper(job_klass, cron_pattern, every_pattern, current_time)

      job_registry.register(job_wrapper)
    end

    Sidekiq::Portal::JobManager.new(job_registry)
  end

  private

  # @return [Hash]
  #
  # @api private
  # @since 0.1.0
  attr_reader :scheduled_jobs_config

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :timezone

  # @param job_config_series [String]
  # @param scheduler_options [Hash]
  # @return [Class]
  #
  # @api private
  # @since 0.1.0
  # @version 0.3.2
  def resolve_job_klass(job_config_series, scheduler_options)
    job_klass_name = scheduler_options['class'] || scheduler_options[:class]
    job_klass = job_klass_name.to_s.constantize rescue nil
    job_klass ||= job_config_series.to_s.constantize rescue nil

    raise(Sidekiq::Portal::ConfusingJobConfigError, <<~ERROR_MESSAGE) unless job_klass
      Can't resolve job class from \"#{job_klass_name || job_config_series}\" job name
    ERROR_MESSAGE

    job_klass
  end

  # @return Array[Time]
  #
  # @api private
  # @since 0.1.0
  def resolve_time_configuration(job_klass, scheduler_options)
    cron_time_pattern  = scheduler_options['cron'] || scheduler_options[:cron]
    every_time_pattern = scheduler_options['every'] || scheduler_options[:every]

    unless cron_time_pattern || every_time_pattern
      raise(Sidekiq::Portal::NoJobTimeConfigurationError, <<~ERROR_MESSAGE)
        Time configuration for "#{job_klass}" job klass is not found
      ERROR_MESSAGE
    end

    if cron_time_pattern && every_time_pattern
      raise(Sidekq::Portal::AmbiguousJobTimeConfigurationError, <<~ERROR_MESSAGE)
        Ambiguous time config (you should provide either <cron> pattern or <every> pattern)
      ERROR_MESSAGE
    end

    [cron_time_pattern, every_time_pattern]
  end

  # @param job_klass [Class]
  # @param cron_pattern [String, NilClass]
  # @param every_pattern [String, NilClass]
  # @param current_time [Time]
  # @return [Sidekiq::Portal::Job]
  #
  # @api private
  # @since 0.1.0
  def build_job_wrapper(job_klass, cron_pattern, every_pattern, current_time)
    Sidekiq::Portal::Job::Builder.build(
      job_klass,
      initial_time: current_time,
      cron_pattern: cron_pattern,
      every_pattern: every_pattern,
      timezone: timezone
    )
  end
end
