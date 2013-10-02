require 'faraday'
require 'json'

module Footrest
  module HttpError
    class ErrorBase < StandardError

      attr_reader :status, :body, :method, :response

      def initialize(response=nil)
        @response = response
        @status = @response[:status]
        @body = @response[:body]
        @method = @response[:method]

        super("HTTP ERROR: #{@status} #{errors}")
      end

      def errors
        JSON::pretty_generate(JSON::parse(@body)["errors"])
      rescue
        @body
      end
    end

    %w(
      BadRequest Unauthorized Forbidden
      NotFound MethodNotAllowed InternalServerError
      NotImplemented BadGateway ServiceUnavailable
    ).each do |error|
      const_set error.to_sym, Class.new(ErrorBase)
    end
  end

  class RaiseFootrestErrors < Faraday::Response::Middleware
    ERROR_MAP = {
      400 => Footrest::HttpError::BadRequest,
      401 => Footrest::HttpError::Unauthorized,
      403 => Footrest::HttpError::Forbidden,
      404 => Footrest::HttpError::NotFound,
      405 => Footrest::HttpError::MethodNotAllowed,
      500 => Footrest::HttpError::InternalServerError,
      501 => Footrest::HttpError::NotImplemented,
      502 => Footrest::HttpError::BadGateway,
      503 => Footrest::HttpError::ServiceUnavailable
    }

    def on_complete(response)
      key = response[:status].to_i
      raise ERROR_MAP[key].new(response) if ERROR_MAP.has_key? key
    end
  end

end