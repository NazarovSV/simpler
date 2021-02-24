require_relative 'render_types/erb'
require_relative 'render_types/plain'

module Simpler
  class View
    DEFAULT_RENDER_TYPE = 'erb'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      render_type = @env['simpler.render_type'] || DEFAULT_RENDER_TYPE
      Simpler.const_get(render_type.capitalize).new(@env).render(binding)
    end
  end
end
