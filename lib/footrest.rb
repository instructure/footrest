require 'footrest/http_error'
require 'footrest/client'
require 'footrest/version'

module Footrest
end

module Faraday
  class Response::Logger < Response::Middleware
    private

    SENSITIVE_HEADERS = %w{Authorization}
    def dump_headers(headers)
      return "empty headers" unless headers
      headers.map { |k, v|
        message = "#{k}: "
        message << (SENSITIVE_HEADERS.include?(k) ? "[filtered]" : v.inspect)
      }.join("\n")
    end
  end
end
