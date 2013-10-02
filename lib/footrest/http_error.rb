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
end