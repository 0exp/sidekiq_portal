# frozen_string_literal: true

# @api private
# @since 0.1.0
module Sidekiq::Portal::CoreExtensions
  require_relative 'core_extensions/timecop'
  require_relative 'core_extensions/sidekiq_worker'
  require_relative 'core_extensions/sidekiq_queue'

  # @since 0.1.0
  @extensions_load_lock = Mutex.new
  # @since 0.1.0
  @extensions_loaded = false

  class << self
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def load!
      @extensions_load_lock.synchronize do
        unless @extensions_loaded
          check_dependencies!
          load_timecop_extension!
          load_sidekiq_extension!
          @extensions_loaded = true
        end
      end
    end

    private

    # @return [void]
    #
    # @raise [Sidekiq::Portal::CoreDependencyNotFoundError]
    # @raise [Sidekiq::Portal::UnsupportedCoreDependencyError]
    #
    # @api private
    # @since 0.1.0
    def check_dependencies!
      unless defined?(::Timecop)
        raise(Sidekiq::Portal::CoreDependencyNotFoundError, '::Timecop not found')
      end

      unless defined?(::Sidekiq)
        raise(Sidekiq::Portal::CoreDependencyNotFoundError, 'Sidekiq not found')
      end

      unless Gem::Version.new(::Timecop::VERSION) >= Gem::Version.new('0.9')
        raise(Sidekiq::Portal::UnsupportedCoreDependencyError, 'Supports timecop@>=0.9 only')
      end

      unless Gem::Version.new(::Sidekiq::VERSION) >= Gem::Version.new('5')
        raise(Sidekiq::Portal::UnsupportedCoreDependencyError, 'Supports sidekiq@>=5 only')
      end

      unless defined?(::Sidekiq::Queue)
        raise(Sidekiq::Portal::CoreDependencyNotFoundError, 'Sidekiq::Queue not found')
      end

      unless defined?(::Sidekiq::Worker)
        raise(Sidekiq::Portal::CoreDependencyNotFoundError, 'Sidekiq::Worker not found')
      end

      unless defined?(::Sidekiq::Testing)
        raise(Sidekiq::Portal::CoreDependencyNotFoundError, 'Sidekiq::Testing not found')
      end
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def load_timecop_extension!
      ::Timecop.prepend(Sidekiq::Portal::CoreExtensions::Timecop)
    end

    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def load_sidekiq_extension!
      ::Sidekiq::Queue.singleton_class.prepend(Sidekiq::Portal::CoreExtensions::SidekiqQueue)
      ::Sidekiq::Worker.singleton_class.prepend(Sidekiq::Portal::CoreExtensions::SidekiqWorker)
    end
  end
end
