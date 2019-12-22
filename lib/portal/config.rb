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

  setting :default_timezone, DEFAULT_TIMEZONE
  setting :retries_count, DEFAUL_RETRIES_COUNT
  setting :scheduler_config, EMPTY_SCHEDULER_CONFIG

  validate :default_timezone do |value|
    value.is_a?(String) && !ActiveSupport::TimeZone[value].nil?
  end

  validate :retries_count, :integer, strict: true
  validate :scheduler_config, :hash, strict: true
end
