require 'footrest/http_error'
require 'footrest/client'
require 'footrest/version'

module Footrest
end

module Faraday
  class Response::Logger < Response::Middleware
    private

    def dump_headers(headers)
      return "empty headers" unless headers
      headers.map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
    end
  end
end