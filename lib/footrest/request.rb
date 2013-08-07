module Footrest
  module Request

    def config
      raise "Config should be overridden"
    end

    def join(*parts)
      joined = parts.map{ |p| p.gsub(%r{^/|/$}, '') }.join('/')
      joined = '/' + joined if parts.first[0] == '/'
      joined
    end

    def fullpath(path)
      config[:prefix] ? join(config[:prefix], path) : path
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