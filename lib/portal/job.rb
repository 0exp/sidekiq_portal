# frozen_string_literal: true

# @api private
# @since 0.1.0
class Sidekiq::Portal::Job
  require_relative 'job/builder'

  # @return [Class]
  #
  # @api public
  # @since 0.1.0
  attr_reader :klass

  # @return [Sidekiq::Portal::JobManager::Timeline]
  #
  # @api private
  # @since 0.1.0
  attr_reader :timeline

  # @param klass [Class] Sidekiq-based ActiveJob class
  # @param timeline [Sidekiq::Portal::Job]
  # @retunr [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(klass, timeline)
    @klass = klass
    @timeline = timeline
    @lock = Sidekiq::Portal::Lock.new
  end

  private

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.thread_safe(&block)
  end
end
