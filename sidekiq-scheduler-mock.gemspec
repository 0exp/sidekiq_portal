# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/scheduler/mock/version'

Gem::Specification.new do |spec|
  spec.name          = 'sidekiq-scheduler-mock'
  spec.version       = Sidekiq::Scheduler::Mock::VERSION
  spec.authors       = ['Rustam Ibragimov']
  spec.email         = ['iamdaiver@gmail.com']

  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = 'https://github.com/0exp/sidekiq-scheduler-mock'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'armitage-rubocop', '~> 0.10.0'
  spec.add_development_dependency 'rspec', '~> 3.8'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
