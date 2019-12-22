# frozen_string_literal: true

# @api private
# @since 0.1.0
module Sidekiq::Portal::CoreExtensions::SidekiqQueue
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def push(*)
    super.tap { Sidekiq::Worker.run_scheduled }
  end
end
