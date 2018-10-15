# frozen_string_literal: true

require 'bundler/setup'
require 'sidekiq_scheduler_mock'
require 'pry'

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.order = :random
  Kernel.srand config.seed
end
