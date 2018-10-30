# frozen_string_literal: true

class Sidekiq::Portal
  # @api public
  # @since 0.1.0
  Error = Class.new(StandardError)

  # @api public
  # @since 0.1.0
  JobConfigNotFoundError = Class.new(Error)

  # @api public
  # @since 0.1.0
  NonSchedulableJobError = Class.new(Error)

  # @api public
  # @since 0.1.0
  TimeConfigNotFoundError = Class.new(Error)

  # @api public
  # @since 0.1.0
  LoadError = Class.new(Error)
end
