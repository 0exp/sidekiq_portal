# frozen_string_literal: true

describe 'Smoke tests' do
  specify 'configuration' do
    portal = Sidekiq::Portal.new do |config|
      config.default_timezone = 'UTC'
      config.retry_count = 1
      config.scheduler_config = {}
    end

    expect(portal.config.settings.default_timezone).to eq('UTC')
    expect(portal.config.settings.retry_count).to eq(1)
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

  describe 'retries' do
    specify 'job retry mechanism emulation' do
      stub_const('RetryLocks', [])
      stub_const('RetryResults', [])
      stub_const('CustomError', Class.new(StandardError))

      stub_const('RetriableJob', Class.new do
        class << self
          def perform_later
            new.perform
          end
        end

        def perform
          if RetryLocks.size < 2
            RetryLocks.push(:locked!)
            raise(CustomError)
          else
            RetryResults.push('working!')
          end
        end
      end)

      Sidekiq::Portal.setup! do |config|
        config.scheduler_config = { RetriableJob: { every: '15m' } }
        config.retry_count = 3
        config.retry_on = [CustomError]
      end

      Timecop.travel(Time.current + 16.minutes)

      expect(RetryLocks).to contain_exactly(:locked!, :locked!)
      expect(RetryResults).to contain_exactly('working!')
    end

    specify 'fails when the possible retry attempts is reached' do
      stub_const('FailResults', [])

      stub_const('FailableJob', Class.new do
        class << self
          def perform_later
            new.perform
          end
        end

        def perform
          FailResults << 1
          raise(ZeroDivisionError) # NOTE: fails every time
        end
      end)

      Sidekiq::Portal.setup! do |config|
        config.scheduler_config = { FailableJob: { every: '15m' } }
        config.retry_count = 100
        config.retry_on = [ZeroDivisionError]
      end

      expect { Timecop.travel(Time.current + 16.minutes) }.to raise_error(ZeroDivisionError)
      expect(FailResults.size).to eq(100)
    end
  end
end
