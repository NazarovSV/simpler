require_relative 'view'

module Simpler
  class Controller
    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers unless @response['Content-Type']
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(options = nil)
      valid_options!(options)

      render_type(options)
    end

    def response_status(status)
      valid_status!(status)

      @response.status = status
    end

    def add_header_to_response(name:, value:)
      @response[name] = value
    end

    def render_type(options)
      if options[:plain]
        @request.env['simpler.render_type'] = 'plain'
        @request.env['simpler.plain_text'] = options[:plain]
      else
        @request.env['simpler.render_type'] = View::DEFAULT_RENDER_TYPE
        @request.env['simpler.template'] = options[:template]
      end
    end

    def valid_status!(status)
      raise "Unknow status #{status}" unless Rack::Utils::HTTP_STATUS_CODES.key?(status)
    end

    def valid_options!(options)
      raise "Invalid parameter #{options}" unless options.is_a?(Hash)
    end


  end
end
