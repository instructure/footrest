module Footrest
  module Request

    def fullpath(path)
      raise "fullpath should be overridden"
    end

    def delete(path, options={})
      request_with_params_in_url(:delete, path, options)
    end

    def get(path, options={})
      request_with_params_in_url(:get, path, options)
    end

    def post(path, options={})
      request_with_params_in_body(:post, path, options)
    end

    def put(path, options={})
      request_with_params_in_body(:put, path, options)
    end

    def patch(path, options={})
      request_with_params_in_body(:patch, path, options)
    end

    def request_with_params_in_url(method, path, options)
      request(method) do |r|
        r.url(fullpath(path), options)
      end
    end

    def request_with_params_in_body(method, path, options)
      request(method) do |r|
        r.path = fullpath(path)
        r.body = options unless options.empty?
      end
    end

    # Generic request
    def request(method, &block)
      connection.send(method, &block).body
    end

  end
end