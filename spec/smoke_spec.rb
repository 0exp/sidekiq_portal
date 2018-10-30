# frozen_string_literal: true

describe 'Load Sidekiq Portal' do
  specify { Sidekiq::Portal.setup! }
end
