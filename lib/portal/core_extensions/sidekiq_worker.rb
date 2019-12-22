# frozen_string_literal: true

# @api private
# @since 0.1.0
module Sidekiq::Portal::CoreExtensions::SidekiqWorker
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def run_scheduled
    timezone = Sidekiq::Portal.config[:default_timezone]
    timezoner = ActiveSupport::TimeZone[timezone]
    current_time = timezoner.at(Time.current)

    jobs.each do |job|
      next if job.key?('at') && timezoner.at(job['at']) > current_time

      Sidekiq::Queues.delete_for(job['jid'], job['queue'], job['class'])
      Sidekiq::Testing.constantize(job['class']).process_job(job)
    end
  end
end
