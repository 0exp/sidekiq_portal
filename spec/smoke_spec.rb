# frozen_string_literal: true

describe 'Load Sidekiq Portal' do
  specify do
    class LolJob; end
    class KekJob; end

    Sidekiq::Portal.setup! do |config|
      config.scheduler_config = {
        LolJob: { every: '5m' },
        KekJob: { every: '1h' },
      }
    end

    timeline = Sidekiq::Portal::JobRunner::Timeline.new(
      Time.current,
      Time.current + 1.hour,
      Fugit::Duration.parse('10m'),
      'UTC'
    )
  end
end
