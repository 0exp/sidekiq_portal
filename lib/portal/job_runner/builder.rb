# frozen_string_literal: true

# @api private
# @since 0.1.0
module Sidekiq::Portal::JobRunner::Builder
  class << self
    # @param config [Sidekiq::Portal::Config]
    # @return [Sidekiq::Portal::JobRunner]
    #
    # @api private
    # @since 0.1.0
    def build(config)
      Sidekiq::Portal::JobRunner.new
    end
  end
end
