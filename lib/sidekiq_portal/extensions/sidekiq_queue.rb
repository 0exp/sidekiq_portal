# frozen_string_literal: true

module Sidekiq::Portal::Extensions
  # @api private
  # @since 0.1.0
  module SidekiqQueue
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def push(*)
      super.tap { Sidekiq::Worker.run_scheduled }
    end
  end
end
