# Changelog
All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-10-05
### Added
- Support for *Rails@8* and *Sidekiq@8*;
- Drop EOL rubies from support (now we supports Ruby >= 3.2);
### Changed
- Updated development dependencies;

## [0.3.2] - 2023-04-27
### Added
- Support for `:class` option name for job class name in scheduler config;

## [0.3.1] - 2022-10-10
### Fixed
- Fixed `ActiveSupport`'s dependnecy lock which did not allow the use of Rails@7;

## [0.3.0] - 2022-10-10
### Added
- Support for Rails@7;
- Support for Sidekiq@6 and experimental Sidekiq@7;

### Changed
- Updated development dependencies;
- Updated core dependencies (`qonfig`, `active_support`, `fugit`);
- Minimal Ruby version - `>= 2.5`;

## [0.2.0] - 2020-01-04
### Added
- Sidekiq's job retry mechanism emulation;

## [0.1.1] - 2019-12-24

### Fixed

- Added missing `Sidekiq::Portal::UnsupportedCoreDependencyError` exception class;

## [0.1.0] - 2019-12-24

- Release 😈
