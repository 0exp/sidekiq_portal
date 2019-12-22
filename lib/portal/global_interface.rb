# frozen_string_literal: true

# @api private
# @since 0.1.0
module Sidekiq::Portal::GlobalInterface
  class << self
    # @param base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.instance_variable_set(:@global_instance, nil)
      base_klass.instance_variable_set(:@global_instance_lock, Mutex.new)
      base_klass.extend(ClassMethods)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @return [Sidekiq::Portal]
    #
    # @api public
    # @since 0.1.0
    def global_instance
      @global_instance_lock.synchronize do
        @global_instance ||= Sidekiq::Portal.new
      end
    end
    alias_method :global, :global_instance

    # @param configuration [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def configure(&configuration)
      global_instance.configure(&configuration)
    end

    # @return [Sidekiq::Portal::Config]
    #
    # @api private
    # @since 0.1.0
    def config
      global_instance.config
    end

    # @param configuration [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def setup!(&configuration)
      global_instance.setup!(&configuration)
    end
    alias_method :reload!, :setup!
  end
end
