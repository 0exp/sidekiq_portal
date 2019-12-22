# frozen_string_literal: true

describe 'Smoke tests' do
  specify 'configuration' do
    portal = Sidekiq::Portal.new do |config|
      config.default_timezone = 'UTC'
      config.retries_count = 1
      config.scheduler_config = {}
    end

    expect(portal.config.settings.default_timezone).to eq('UTC')
    expect(portal.config.settings.retries_count).to eq(1)
    expect(portal.config.settings.scheduler_config).to eq({})
  end

  specify 'time traveling' do
    stub_const('LolJobResults', [])
    stub_const('KekJobResults', [])

    stub_const('LolJob', Class.new do
      class << self
        def perform_later
          new.perform
        end
      end

      def perform
        LolJobResults << Time.current
      end
    end)

    stub_const('KekJob', Class.new do
      class << self
        def perform_later
          new.perform
        end
      end

      def perform
        KekJobResults << Time.current
      end
    end)

    Sidekiq::Portal.setup! do |config|
      config.scheduler_config = {
        LolJob: { every: '15m' },
        KekJob: { every: '1h' }
      }
    end

    Timecop.travel(Time.current + 2.hours)

    expect(LolJobResults.size).to eq(8)
    expect(KekJobResults.size).to eq(2)
  end
end
