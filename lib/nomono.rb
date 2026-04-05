# frozen_string_literal: true

# External gems
require "version_gem"

# This gem
require_relative "nomono/version"

require_relative "nomono/resolver"
require_relative "nomono/dsl"

module Nomono
  class Error < StandardError; end

  module_function

  def resolver
    Resolver.new
  end

  def install!(dsl_class = nil)
    dsl_class ||= Bundler::Dsl if defined?(Bundler::Dsl)
    return false unless dsl_class

    dsl_class.include(GemfileDsl) unless dsl_class < GemfileDsl
    true
  end
end

Nomono.install!

Nomono::Version.class_eval do
  extend VersionGem::Basic
end
