# frozen_string_literal: true

class SidekiqSchedulerMock
  # @api private
  # @since 0.1.0
  module Loader
    class << self
      # @return [void]
      #
      # @api private
      # @since 0.1.0
      def load!
        check_dependencies!
        load_extensions!
        init_global_instance!
      end

      private

      # @return [void]
      #
      # @raise [SidekiqSchedulerMock::LoadError]
      #
      # @api private
      # @since 0.1.0
      def check_dependencies!
        raise LoadError unless defined?(::Timecop)
        raise LoadError unless defined?(::Sidekiq)
        raise LoadError unless defined?(::Sidekiq::Queue)
        raise LoadError unless defined?(::Sidekiq::Worker)
        raise LoadError unless defined?(::Sidekiq::Testing)
      end

      # @return [void]
      #
      # @api private
      # @since 0.1.0
      def load_extensions!
        Extensions.load!
      end

      # @return [void]
      #
      # @api private
      # @since 0.1.0
      def init_global_instance!
        SidekiqSchedulerMock.global_instance
      end
    end
  end
end
