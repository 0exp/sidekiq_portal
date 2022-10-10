# frozen_string_literal: true

require 'qonfig'
require 'fugit'
require 'active_support/isolated_execution_state'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/time'
require 'active_support/core_ext/time/calculations'

# @api public
# @since 0.1.0
module Sidekiq
  # @api public
  # @since 0.1.0
  class Portal
    require_relative 'portal/version'
    require_relative 'portal/errors'
    require_relative 'portal/lock'
    require_relative 'portal/config'
    require_relative 'portal/timeline'
    require_relative 'portal/job'
    require_relative 'portal/job_registry'
    require_relative 'portal/job_manager'
    require_relative 'portal/job_runner'
    require_relative 'portal/core_extensions'
    require_relative 'portal/global_interface'

    # @since 0.1.0
    include Sidekiq::Portal::GlobalInterface

    # @return [Sidekiq::Portal::Config]
    #
    # @api public
    # @since 0.1.0
    attr_reader :config

    # @param configuration [Block]
    # @yield [config]
    # @yieldparam config [Qonfig::Settings]
    # @yieldreturn [void]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def initialize(&configuration)
      @lock = Sidekiq::Portal::Lock.new
      thread_safe { setup!(&configuration) }
    end

    # @param configuration [Block]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def setup!(&configuration)
      thread_safe do
        Sidekiq::Portal::CoreExtensions.load!

        @config = Sidekiq::Portal::Config.new(&configuration)
        @job_manager = Sidekiq::Portal::JobManager::Builder.build(@config)
        @job_runner = Sidekiq::Portal::JobRunner::Builder.build(@config)
      end
    end
    alias_method :reload!, :setup!

    # @param configuration [Block]
    # @yield [config]
    # @yieldparam config [Qonfig::DataSet]
    # @yieldreturn [void]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def configure(&configuration)
      thread_safe { config.configure(&configuration) }
    end

    # @param job_klass [Class]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def run_job(job_klass)
      thread_safe do
        raise(
          Sidekiq::Portal::NonSchedulableJobError,
          "#{job_klas} is not schedulable"
        ) unless job_manager.runnable?(job_klass)

        portal_job = job_manager.resolve(job_klass)
        job_runner.run(portal_job)
      end
    end

    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def run_all
      thread_safe do
        job_manager.each_time_point do |time_point|
          ::Timecop.freeze(time_point) do
            job_manager.each_job { |job| job_runner.run(job) }
          end
        end
      end
    end

    private

    # @return [Sidekiq::Portal::JobManager]
    #
    # @api private
    # @since 0.1.0
    attr_reader :job_manager

    # @return [Sidekiq::Portal::JobRunner]
    #
    # @api private
    # @since 0.1.0
    attr_reader :job_runner

    # @param block [Block]
    # @return [Any]
    #
    # @api private
    # @since 0.1.0
    def thread_safe(&block)
      @lock.thread_safe(&block)
    end
  end
end
