# Sidekiq::Portal

`Sidekiq::Portal` - scheduled jobs runner for your test environments,
which exection must occur during the `Timecop.travel(...)` operation according to the scheduler config.

Each job starts at the time it was supposed to start according to the scheduler -
internal `Time.current` expression will contain exactly the scheduler-planned time.

Works with `sidekiq-scheduler`-based job configs (`sidekiq-cron` coming soon).

Supports `ActiveJob` backend (`Sidekiq::Worker` coming soon).

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

- `default_timezone` (`UTC` by default) - global time zone for your jobs;
- `retries_count` - recurring job simulation;
- `scheduler_config` - `sidekiq-scheduler`-based scheduler configuration;;
- `Sidekiq::Portal.reload!(&configuration)` - reload portal configurations;

In your `spec_helper.rb`:

```ruby
# portal configuration
Sidekiq::Portal.setup! do |config|
  config.default_timezone = 'UTC'
  config.retries_count = 1

  # pre-defined sidekiq-scheduler configs (Rails example)
  config.scheduler_cofnig = Rails.application.config_for(:sidekiq)[:schedule]

  # manual sidekiq-scheduler configs
  config.schedluer_config = {
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

- Documentation and examples for instance-based portals (`Sidekiq::Portal.new(&configuration)`);
- `Sidekiq::Testing.portal!` test mode with support for `:inline` and `:fake`;
  (`Sidekiq::Testing.inline!` and `Sidekiq::Testing.fake` respectively);
- support for `ActiveSupport::Timezone` instances in `default_timezone` config;
- support for retries;
- rspec matchers;
- `#reload!` should use previosly defined settings?;
- support for `Sidekiq::Worker` job backend;
- support for `Sidekiq::Cron` scheduler plans;
- more specs;

## License

Released under MIT License.

## Authors

[Rustam Ibragimov](https://github.com/0exp)
