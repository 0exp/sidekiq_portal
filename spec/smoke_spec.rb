# frozen_string_literal: true

describe 'Load Sidekiq Portal' do
  specify do
    class LolJob
      class << self
        def perform_later
          new.perform
        end
      end

      def perform
        puts "#{self.class.name} => #{Time.current}"
      end
    end

    class KekJob
      class << self
        def perform_later
          new.perform
        end
      end

      def perform
        puts "#{self.class.name} => #{Time.current}"
      end
    end


    Sidekiq::Portal.setup! do |config|
      config.scheduler_config = {
        LolJob: { every: '15m' },
        KekJob: { every: '1h' },
      }
    end

    Timecop.travel(Time.current + 2.hours)
  end
end
