# frozen_string_literal: true

require_relative "lib/nomono/version"

Gem::Specification.new do |spec|
  spec.name = "nomono"
  spec.version = Nomono::VERSION
  spec.authors = ["Peter H. Boling"]
  spec.email = ["peter.boling@gmail.com"]

  spec.summary = "1️⃣ ENV-driven Gemfile macros for sibling gem path resolution"
  spec.description = "1️⃣ Provides nomono_gems and eval_nomono_gems to standardize local multi-repo dependency wiring in Gemfiles."
  spec.homepage = "https://github.com/kettle-rb/nomono"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Utilities
  spec.add_dependency("version_gem", "~> 1.1", ">= 1.1.9")              # ruby >= 2.2.0
  # FFI is required at runtime if no other backends are configured since it can load on all Rubies
  # But we keep it as an option dependency to reduce the footprint of this gem,
  #   since if you configure a different backend, it would not get used.
  # spec.add_dependency("ffi", ">= 1.15", "< 2.0")

  # NOTE: It is preferable to list development dependencies in the gemspec due to increased
  #       visibility and discoverability.
  #       However, development dependencies in gemspec will install on
  #       all versions of Ruby that will run in CI.
  #       This gem, and its gemspec runtime dependencies, will install on Ruby down to 3.2.0.
  #       This gem, and its gemspec development dependencies, will install on Ruby down to 3.2.0.
  #       Thus, dev dependencies in gemspec must have
  #
  #       required_ruby_version ">= 3.2.0" (or lower)
  #
  #       Development dependencies that require strictly newer Ruby versions should be in a "gemfile",
  #       and preferably a modular one (see gemfiles/modular/*.gemfile).

  # Dev, Test, & Release Tasks
  spec.add_development_dependency("kettle-dev", "~> 2.0")                           # ruby >= 2.3.0

  # Security
  spec.add_development_dependency("bundler-audit", "~> 0.9.3")                      # ruby >= 2.0.0

  # Tasks
  spec.add_development_dependency("rake", "~> 13.0")                                # ruby >= 2.2.0

  # Debugging
  spec.add_development_dependency("require_bench", "~> 1.0", ">= 1.0.4")            # ruby >= 2.2.0

  # Testing
  spec.add_development_dependency("appraisal2", "~> 3.0", ">= 3.0.6")               # ruby >= 1.8.7, for testing against multiple versions of dependencies
  spec.add_development_dependency("kettle-soup-cover", "~> 1.1", ">= 1.1.1")        # ruby >= 2.7
  spec.add_development_dependency("kettle-test", "~> 1.0", ">= 1.0.10")              # ruby >= 2.3

  # Releasing
  spec.add_development_dependency("ruby-progressbar", "~> 1.13")                    # ruby >= 0
  spec.add_development_dependency("stone_checksums", "~> 1.0", ">= 1.0.3")          # ruby >= 2.2.0

  # Git integration (optional)
  # The 'git' gem is optional; tree_haver falls back to shelling out to `git` if it is not present.
  # The current release of the git gem depends on activesupport, which makes it too heavy to depend on directly
  # spec.add_dependency("git", ">= 1.19.1")                               # ruby >= 2.3

  # Development tasks
  # The cake is a lie. erb v2.2, the oldest release, was never compatible with Ruby 2.3.
  # This means we have no choice but to use the erb that shipped with Ruby 2.3
  # /opt/hostedtoolcache/Ruby/2.3.8/x64/lib/ruby/gems/2.3.0/gems/erb-2.2.2/lib/erb.rb:670:in `prepare_trim_mode': undefined method `match?' for "-":String (NoMethodError)
  # spec.add_development_dependency("erb", ">= 2.2")                                  # ruby >= 2.3.0, not SemVer, old rubies get dropped in a patch.
  spec.add_development_dependency("gitmoji-regex", "~> 1.0", ">= 1.0.3")            # ruby >= 2.3.0
  # ruby >= 2.3.0

  # HTTP recording for deterministic specs
  # In Ruby 3.5 (HEAD) the CGI library has been pared down, so we also need to depend on gem "cgi" for ruby@head
  # This is done in the "head" appraisal.
  # See: https://github.com/vcr/vcr/issues/1057
  # spec.add_development_dependency("vcr", ">= 4")                        # 6.0 claims to support ruby >= 2.3, but fails on ruby 2.4
  # spec.add_development_dependency("webmock", ">= 3")                    # Last version to support ruby >= 2.3
end
