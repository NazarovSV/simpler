require 'logger'

class AppLogger
  include Rack::Utils

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || $stdout)
    @app = app
  end

  def call(env)
    log_request(env: env)

    status, header, body = @app.call(env)

    log_handler(env: env)
    log_parameters(env: env)
    log_response(status: status, header: header, env: env)

    [status, header, body]
  end

  private

  def log_request(env:)
    method = env['REQUEST_METHOD']
    full_path = env['REQUEST_URI']
    @logger.info("Request: #{method} #{full_path}")
  end

  def log_handler(env:)
    @logger.info("Handler: #{env['simpler.handler']}") if env['simpler.handler']
  end

  def log_parameters(env:)
    @logger.info("Parameters: #{env['simpler.parameters']}") if env['simpler.parameters']
  end

  def log_response(status:, header:, env:)
    @logger.info("Response: #{status} #{HTTP_STATUS_CODES[status]} [#{header['Content-Type']}] #{env['simpler.template_path']}")
  end
end
