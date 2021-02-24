module Simpler
  class Plain
    def initialize(env)
      @env = env
    end

    def render(_binding)
      @env['simpler.plain_text']
    end
  end
end
