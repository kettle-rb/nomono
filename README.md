# 1️⃣ Nomono

`nomono` standardizes local sibling-gem dependency loading for multi-repo setups.

It provides two Gemfile macros:

- `nomono_gems(**opts)` returns `{ gem_name => absolute_path }`
- `eval_nomono_gems(**opts)` directly emits `gem "name", path: "..."`

The API mirrors existing `*_local.gemfile` patterns used in kettle-rb projects, but centralizes path/env logic in one reusable library.

## Installation

Install the gem and add it to your `Gemfile`:

```bash
bundle add nomono
```

Or install directly:

```bash
gem install nomono
```

## Usage

In your Gemfile (or a modular Gemfile loaded via `eval_gemfile`):

```ruby
require "nomono/bundler"

local_gems = %w[
  kettle-dev
  kettle-test
  kettle-soup-cover
]

if ENV.fetch("KETTLE_RB_DEV", "false").casecmp("false").zero?
  # remote/released gems
  gem "kettle-soup-cover", require: false
else
  eval_nomono_gems(gems: local_gems, prefix: "KETTLE_RB")
end
```

### Environment contract

By default (`prefix: "NOMONO_GEMS"`):

- `NOMONO_GEMS_DEV` controls local mode (`false` disables; `true` uses `~/src/kettle-rb`; any other value is a path)
- `NOMONO_GEMS_VENDORED_GEMS` (or legacy `VENDORED_GEMS`) is a comma-delimited list of gems resolved from vendor dir
- `NOMONO_GEMS_VENDOR_GEM_DIR` (or legacy `VENDOR_GEM_DIR`) points at the vendor base path
- `NOMONO_GEMS_DEBUG` enables debug output

Override env variable names with options:

```ruby
nomono_gems(
  gems: %w[rubocop-lts rubocop-ruby3_2],
  prefix: "RUBOCOP_LTS",
  path_env: "RUBOCOP_LTS_LOCAL",
  vendored_gems_env: "VENDORED_GEMS",
  vendor_gem_dir_env: "VENDOR_GEM_DIR",
  debug_env: "RUBOCOP_LTS_DEBUG"
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then run specs:

```bash
bundle exec rspec
```

To install locally:

```bash
bundle exec rake install
```

## Contributing

Bug reports and pull requests are welcome.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Nomono project is expected to follow the code of conduct.
