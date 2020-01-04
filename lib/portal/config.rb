# frozen_string_literal: true

# @api public
# @since 0.1.0
class Sidekiq::Portal::Config < Qonfig::DataSet
  # @return [String]
  #
  # @api private
  # @since 0.1.0
  DEFAULT_TIMEZONE = 'UTC'

  # @return [Hash]
  #
  # @api private
  # @since 0.1.0
  EMPTY_SCHEDULER_CONFIG = {}.freeze

  # @return [Integer]
  #
  # @api private
  # @since 0.1.0
  DEFAUL_RETRIES_COUNT = 0

  # @return [Array<Exception>]
  #
  # @api private
  # @since 0.1.0
  RETRY_ON_EXCEPTIONS = [StandardError].freeze

  # @since 0.1.0
  setting :default_timezone, DEFAULT_TIMEZONE
  # @since 0.1.0
  setting :retry_count, DEFAUL_RETRIES_COUNT
  # @since 0.1.0
  setting :retry_on, RETRY_ON_EXCEPTIONS
  # @since 0.1.0
  setting :scheduler_config, EMPTY_SCHEDULER_CONFIG

  # @since 0.1.0
  validate :default_timezone do |value|
    value.is_a?(String) && !ActiveSupport::TimeZone[value].nil?
  end

  # @since 0.1.0
  validate :retry_on do |value|
    value.is_a?(Array) && (value.all? do |exception_klass|
      exception_klass.is_a?(Class) && exception_klass <= ::Exception
    end)
  end

  # @since 0.1.0
  validate :retry_count, :integer, strict: true
  # @since 0.1.0
  validate :scheduler_config, :hash, strict: true
end
