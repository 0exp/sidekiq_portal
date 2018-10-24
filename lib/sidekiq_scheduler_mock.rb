# frozen_string_literal: true

require 'fugit'
require 'qonfig'
require 'concurrent/map'
require 'active_support/core_ext/time'

# @api public
# @since 0.1.0
class SidekiqSchedulerMock
  require_relative 'sidekiq_scheduler_mock/version'
  require_relative 'sidekiq_scheduler_mock/error'
  require_relative 'sidekiq_scheduler_mock/job_manager'
  require_relative 'sidekiq_scheduler_mock/job_runner'
  require_relative 'sidekiq_scheduler_mock/extensions'
  require_relative 'sidekiq_scheduler_mock/loader'

  class << self
    # @since 0.1.0
    extend Forwardable

    # @since 0.1.0
    def_delegators :global_instance, :run, :run_all, :schedulable?, :reload!

    # @param config_instructions [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def setup!(&config_instructions)
      configure(&config_instructions) if block_given?
      Loader.load!
    end

    # @return [SidekiqSchedulerMock]
    #
    # @api private
    # @since 0.1.0
    def global_instance
      @global_instance ||= new
    end
  end

  # @since 0.1.0
  include Qonfig::Configurable

  # @since 0.1.0
  extend Forwardable

  # @since 0.1.0
  configuration do
    setting :default_timezone, 'UTC'
    setting :retries, 0
    setting :scheduler_config, {}
  end

  # @since 0.1.0
  def_delegators :job_manager, :schedulable?, :state_of

  # @return [SidekiqSchedulerMock::JobManager]
  #
  # @api public
  # @since 0.1.0
  attr_reader :job_manager

  # @return [SidekiqSchedulerMock::JobRunner]
  #
  # @api private
  # @since 0.1.0
  attr_reader :job_runner

  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def initialize
    setup!
  end

  # @param job_klass [Class<ActiveJob::Base>]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def run(job_klass)
    raise NonSchedulableJobError unless schedulable?(job_klass)
    job_runner.perform(state_of(job_klass))
  end

  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def run_all
    job_manager.each_job { |job_klass| run(job_klass) }
  end

  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def reload!
    setup!
  end

  private

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def setup!
    @job_manager = build_job_manager!
    @job_runner  = build_job_runner!
  end

  # @return [SidekiqSchedulerMock::JobManager]
  #
  # @api private
  # @since 0.1.0
  def build_job_manager!
    JobManager.build(
      scheduler_config: shared_config[:scheduler_config],
      timezone: shared_config[:default_timezone]
    )
  end

  # @return [SidekiqSchedulerMock::JobRunner]
  #
  # @api private
  # @since 0.1.0
  def build_job_runner!
    JobRunner.build(retries: shared_config[:retries])
  end
end
