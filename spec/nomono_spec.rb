# frozen_string_literal: true

RSpec.describe Nomono do
  it "has a version number" do
    expect(Nomono::VERSION).not_to be_nil
  end

  describe ".resolver" do
    it "builds a resolver" do
      expect(described_class.resolver).to be_a(Nomono::Resolver)
    end
  end

  describe ".install!" do
    it "adds macros to a provided DSL class" do
      dsl = Class.new

      expect(described_class.install!(dsl)).to be(true)
      expect(dsl.instance_methods).to include(:nomono_gems, :eval_nomono_gems)
    end

    it "returns true when macros are already installed" do
      dsl = Class.new do
        include Nomono::GemfileDsl
      end

      expect(described_class.install!(dsl)).to be(true)
    end

    it "returns false without a provided or loaded Bundler DSL class" do
      hide_const("Bundler")

      expect(described_class.install!).to be(false)
    end
  end
end
