# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/portal/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.2'

  spec.name = 'sidekiq_portal'
  spec.version = Sidekiq::Portal::VERSION
  spec.authors = ['Rustam Ibragimov']
  spec.email = ['exfivedaiver@gmail.com']

  spec.summary =
    'Sidekiq::Portal - scheduled jobs invocation emulation for test environments '
  spec.description =
    'Sidekiq::Portal - emulate scheduled job activity in tests when you work with time traveling.'

  spec.homepage = 'https://github.com/0exp/sidekiq_portal'
  spec.license = 'MIT'

  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_dependency 'qonfig', '~> 0.28'
  spec.add_dependency 'fugit', '~> 1.7'
  spec.add_dependency 'activesupport', '>= 4', '< 9'
end
