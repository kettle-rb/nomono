# frozen_string_literal: true

RSpec.describe Nomono::Resolver do
  subject(:resolver) { described_class.new(env: env, home: "/home/test") }

  let(:env) { {} }

  describe "#gems" do
    let(:gems) { %w[kettle-dev kettle-test kettle-soup-cover] }

    it "returns empty hash when local mode is disabled" do
      env["NOMONO_GEMS_DEV"] = "false"

      expect(resolver.gems(gems: gems)).to eq({})
    end

    it "resolves siblings from default root when local mode is enabled" do
      env["NOMONO_GEMS_DEV"] = "true"

      expect(resolver.gems(gems: gems)).to eq(
        "kettle-dev" => "/home/test/src/kettle-rb/kettle-dev",
        "kettle-test" => "/home/test/src/kettle-rb/kettle-test",
        "kettle-soup-cover" => "/home/test/src/kettle-rb/kettle-soup-cover",
      )
    end

    it "supports vendored overrides with legacy env variable names" do
      env["NOMONO_GEMS_DEV"] = "/workspace/kettle-rb"
      env["VENDORED_GEMS"] = "kettle-test"
      env["VENDOR_GEM_DIR"] = "/workspace/kettle-rb/vendor"

      expect(resolver.gems(gems: gems)).to eq(
        "kettle-dev" => "/workspace/kettle-rb/kettle-dev",
        "kettle-test" => "/workspace/kettle-rb/vendor/kettle-test",
        "kettle-soup-cover" => "/workspace/kettle-rb/kettle-soup-cover",
      )
    end

    it "supports alternate family prefixes" do
      env["KETTLE_RB_DEV"] = "relative/path"

      expect(
        resolver.gems(
          gems: gems,
          prefix: "KETTLE_RB",
          vendored_gems_env: "KETTLE_RB_VENDORED_GEMS",
          vendor_gem_dir_env: "KETTLE_RB_VENDOR_GEM_DIR",
        ),
      ).to include("kettle-dev" => "/home/test/relative/path/kettle-dev")
    end
  end
end
