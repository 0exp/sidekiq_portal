# frozen_string_literal: true

# @api private
# @since 0.1.0
class Sidekiq::Portal::Lock
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @lock = Mutex.new
  end

  # @param block [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    lock.owned? ? yield : lock.synchronize(&block)
  end

  private

  # @return [Mutex]
  #
  # @api private
  # @since 0.1.0
  attr_reader :lock
end
