# frozen_string_literal: true

# @api public
# @since 0.1.0
class Sidekiq::Portal
  # @api public
  # @since 0.1.0
  Error = Class.new(StandardError)

  # @api pulbic
  # @since 0.1.0
  ArgumentError = Class.new(ArgumentError)

  # @api public
  # @since 0.1.0
  NonScheduledJobClassError = Class.new(Error)

  # @api public
  # @since 0.1.0
  JobConfigurationNotFoundError = Class.new(Error)

  # @api public
  # @since 0.1.0
  NonSchedulableJobError = Class.new(Error)

  # @api public
  # @since 0.1.0
  UnsupportedCoreDependencyError = Class.new(Error)

  # @api public
  # @since 0.1.0
  CoreDependencyNotFoundError = Class.new(Error)

  # @api public
  # @since 0.1.0
  ConfusingJobConfigError = Class.new(Error)
end
