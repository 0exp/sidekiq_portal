# frozen_string_literal: true

module Sidekiq::Portal::Extensions
  # @api private
  # @since 0.1.0
  module Timecop
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def travel(*)
      super.tap do
        Sidekiq::Portal.run_all
        Sidekiq::Worker.run_scheduled
      end
    end
  end
end
