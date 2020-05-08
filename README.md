# Sidekiq::Portal [![Gem Version](https://badge.fury.io/rb/sidekiq_portal.svg)](https://badge.fury.io/rb/sidekiq_portal) [![Build Status](https://travis-ci.org/0exp/sidekiq_portal.svg?branch=master)](https://travis-ci.org/0exp/sidekiq_portal)

> hackaton slides: [link](https://github.com/0exp/sidekiq_portal/blob/master/docs/umbrellio_hackaton_v1.0.pdf)

> meetup slides: [link](https://github.com/0exp/sidekiq_portal/blob/master/docs/sidekiq_portal_ruby_group_meetup.pdf)

> meetup video: [link](https://youtu.be/H3SafkpBQ_w?t=12288)

**Sidekiq::Portal** - scheduled jobs runner for your test environments,
which execution process must occur during the `Timecop.travel(...)` operations according to the scheduler config.

Each job starts at the time it was supposed to start according to the scheduler plan -
the internal `Time.current` expression will give you exactly the scheduler-planned time.

Supports **ActiveJob** backend (**Sidekiq::Worker** coming soon). Works with **sidekiq-scheduler**-based job configs (**sidekiq-cron** coming soon).

Realized as an instance, but have a global-based implementation too.

## Table of contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Example](#example)
- [Roadmap](#roadmap)
- [License](#license)
- [Authors](#authors)

## Installation

- in your `Gemfile`

```ruby
gem 'sidekiq', '>= 5' # runtime dependency
gem 'timecop', '~> 0.9' # runtime dependency

group :test do
  gem 'rspec'
  gem 'sidekiq-portal'
end
```

- run shell command:

```shell
bundle install
```

- `scec_helper.rb`:

```ruby
require 'timecop' # runtime dependency
require 'sidekiq' # runtime dependency
require 'sidekiq/api'
require 'sidekiq/testing'

require 'sidekiq_portal'
```

## Configuration

- `default_timezone` - global time zone for your jobs (`UTC` by default);
- `retry_count` - Sidekiq's built-in retry mechanism simulation (`0` by default);
- `retry_on` - retry only on a set of exceptions (`[StandardError]` by default);
- `scheduler_config` - `sidekiq-scheduler`-based scheduler configuration (`{}` by default (non-configured));
- `Sidekiq::Portal.reload!(&configuration)` - reload portal configurations;

In your `spec_helper.rb`:

```ruby
# portal configuration
Sidekiq::Portal.setup! do |config|
  config.default_timezone = 'UTC' # 'UTC' by default
  config.retry_count = 3 # 0 by default
  config.retry_on = [StandardError] # [StandardError] by default

  # pre-defined sidekiq-scheduler configs (Rails example)
  config.scheduler_config = Rails.application.config_for(:sidekiq)[:schedule]

  # manual sidekiq-scheduler configs
  config.scheduler_config = {
    LoolJob: { every: '15m' },
    kek_job: { cron: '0 * * * * *', class: :KekJob }
  }
end

# global state clearing logic
RSpec.configure do |config|
  config.before { Sidekiq::Worker.clear_all }
  config.after  { Timecop.return }
  config.after  { Sidekiq::Portal.reload! }
end
```

And in your tests:

```ruby
RSpec.describe 'Some spec' do
  specify 'magic?' do
    Timecop.travel(Time.current + 2.hours) # magic begins here 😈
  end
end
```

## Example

- Job class:

```ruby
class HookExampleJob < ApplicationJob
  def perform
    GLOBAL_HOOK_INTERCEPTOR << Time.current # intercept current time
  end
end
```

- `Sidekiq::Scheduler` config:

```yaml
:schedule:
  HookExample:
    every: '15m'
```

- `HookExampleJob` spec:

```ruby
RSpec.describe 'HookExampleJob sheduler plan' do
  specify 'scheduled?' do
    stub_const('GLOBAL_HOOK_INTERCEPTOR', [])
    expect(GLOBAL_HOOK_INTERCEPTOR.count).to eq(0) # => true

    # do some magic 😈
    Timecop.travel(Time.current + 2.hours)

    expect(GLOBAL_HOOK_INTERCEPTOR.count).to eq(8) # => true (😈 magic)

    puts GLOBAL_HOOK_INTERCEPTOR # 😈
    # => outputs:
    # 2019-12-24 03:05:39 +0300 (+15m) (Time.current from HookExampleJob#perform)
    # 2019-12-24 03:20:39 +0300 (+15m)
    # 2019-12-24 03:35:39 +0300 (+15m)
    # 2019-12-24 03:50:39 +0300 (+15m)
    # 2019-12-24 04:05:39 +0300 (+15m)
    # 2019-12-24 04:20:39 +0300 (+15m)
    # 2019-12-24 04:35:39 +0300 (+15m)
    # 2019-12-24 04:50:39 +0300 (+15m)
  end
end
```

## Roadmap

- `Sidekiq::Testing.portal!` test mode with support for `:inline` and `:fake`;
  (`Sidekiq::Testing.inline!` and `Sidekiq::Testing.fake` respectively);
- support for `ActiveSupport::TimeZone` instances in `default_timezone` config;
- rspec matchers;
- `#reload!` should use previosly defined settings?;
- support for `Sidekiq::Worker` job backend;
- support for `Sidekiq::Cron` scheduler plans;
- more specs;
- documentation and examples for instance-based portals (`Sidekiq::Portal.new(&configuration)`);
- configurable job execution randomization (for jobs which should be invoked at the same time)
  (randomized invokation and not - at the same time or not);
- configurable in-line invokations (with job list config);
- configurable and conditional portal invokation (run over all specs or only over the one or etc)
  (suitable for unit tests);
- support for **Ruby 2.7**;
- **Time** as external dependency;
- getting rid of **ActiveSupport**'s **Time**-related core extentions;
- better specs;

## License

Released under MIT License.

## Authors

[Rustam Ibragimov](https://github.com/0exp)
