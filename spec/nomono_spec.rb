# frozen_string_literal: true

RSpec.describe Nomono do
  it "has a version number" do
    expect(Nomono::VERSION).not_to be nil
  end

  describe ".install!" do
    it "adds macros to a provided DSL class" do
      dsl = Class.new

      expect(described_class.install!(dsl)).to eq(true)
      expect(dsl.instance_methods).to include(:nomono_gems, :eval_nomono_gems)
    end
  end
end
