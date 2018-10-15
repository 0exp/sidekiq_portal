# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq_scheduler_mock/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.3.7'

  spec.name          = 'sidekiq-scheduler-mock'
  spec.version       = SidekiqSchedulerMock::VERSION
  spec.authors       = ['Rustam Ibragimov']
  spec.email         = ['iamdaiver@gmail.com']

  spec.summary       = 'SidekiqScheduler mock for your tests.'
  spec.description   = 'SidekiqScheduler mock for your tests that emulates ' \
                       'main functionality of the real SidekiqScheduler gem.'

  spec.homepage      = 'https://github.com/0exp/sidekiq-scheduler-mock'
  spec.license       = 'MIT'
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  end

  spec.add_development_dependency 'armitage-rubocop', '~> 0.10.0'
  spec.add_development_dependency 'rspec',            '~> 3.8'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
end
