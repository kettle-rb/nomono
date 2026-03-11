# frozen_string_literal: true

module Nomono
  module GemfileDsl
	def nomono_gems(gems:, **opts)
	  Nomono.resolver.gems(gems: gems, **opts)
	end

	def eval_nomono_gems(gems:, **opts)
	  nomono_gems(gems: gems, **opts).each do |gem_name, gem_path|
		gem(gem_name, path: gem_path)
	  end
	end
  end
end
