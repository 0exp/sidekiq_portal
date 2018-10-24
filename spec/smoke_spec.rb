# frozen_string_literal: true

describe 'Load Scheduler Mock' do
  specify { SidekiqSchedulerMock.setup! }
end
