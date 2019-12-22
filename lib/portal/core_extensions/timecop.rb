# frozen_string_literal: true

# @api private
# @since 0.1.0
module Sidekiq::Portal::CoreExtensions::Timecop
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def travel(*)
    super.tap do
      Sidekiq::Portal.global.run_all
      Sidekiq::Worker.run_scheduled
    end
  end
end
