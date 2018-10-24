# frozen_string_literal: true

# @api private
# @since 0.1.0
module SidekiqSchedulerMock::Extensions
  require_relative 'extensions/timecop'
  require_relative 'extensions/sidekiq_worker'
  require_relative 'extensions/sidekiq_queue'

  class << self
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def load!
      load_timecop_extension!
      load_sidekiq_extension!
      load_scheduler_aliases!
    end

    private

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def load_timecop_extension!
      ::Timecop.prepend(Timecop)
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def load_sidekiq_extension!
      ::Sidekiq::Queue.singleton_class.prepend(SidekiqQueue)
      ::Sidekiq::Worker.singleton_class.prepend(SidekiqWorker)
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def load_scheduler_aliases!
      require_relative 'extensions/scheduler_aliases'
    end
  end
end
