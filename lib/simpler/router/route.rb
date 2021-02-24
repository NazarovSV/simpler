module Simpler
  class Router
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params_index = parse_params(path)
      end

      def match?(method, path)
        @method == method && match_path?(path)
      end

      def params(path)
        path_fragments = path_array(path)
        @params_index.map { |key, value| { key[1..-1].to_sym => path_fragments[value] } }.reduce({}, :merge)
      end

      private

      def match_path?(path)
        router_path = path_array(@path)
        request_path = path_array(path)

        return false unless router_path.size == request_path.size

        router_path.each_with_index do |route_chunk, index|
          return false if !route_chunk.start_with?(':') && route_chunk != request_path[index]
        end

        true
      end

      def parse_params(path)
        path_array(path).each_with_index.map do |path_chunk, index|
          path_chunk.start_with?(':') ? { path_chunk => index } : {}
        end.reduce({}, :merge)
      end

      def path_array(path)
        path.downcase.split('/').reject(&:empty?)
      end
    end
  end
end
