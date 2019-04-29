# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq_portal/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.3.8'

  spec.name          = 'sidekiq-portal'
  spec.version       = Sidekiq::Portal::VERSION
  spec.authors       = ['Rustam Ibragimov']
  spec.email         = ['iamdaiver@gmail.com']

  spec.summary       = 'Sidekiq::Portal - worker scheduler mock for your tests.'
  spec.description   = 'Sidekiq::Portal - worker scheduler mock for your tests that emulates ' \
                       'job activity when you work with time traveling.'

  spec.homepage      = 'https://github.com/0exp/sidekiq-portal'
  spec.license       = 'MIT'
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  end

  spec.add_dependency 'qonfig'
  spec.add_dependency 'concurrent-ruby'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'fugit'

  spec.add_development_dependency 'armitage-rubocop', '~> 0.26'
  spec.add_development_dependency 'rspec',            '~> 3.8'
  spec.add_development_dependency 'coveralls',        '~> 0.8'
  spec.add_development_dependency 'simplecov',        '~> 0.16'

  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'sidekiq'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
end
