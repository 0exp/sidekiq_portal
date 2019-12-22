# frozen_string_literal: true

require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
SimpleCov.start { add_filter 'spec' }

require 'bundler/setup'
require 'sidekiq_portal'
require 'pry'

require 'timecop'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/testing'

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.order = :random
  config.shared_context_metadata_behavior = :apply_to_host_groups
  Kernel.srand config.seed
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  Thread.abort_on_exception = true
end
