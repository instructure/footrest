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

        super("HTTP ERROR: #{status} (#{status_message}) #{method} #{url}\n#{errors}\n#{headers}")
      end

      def method
        @method.to_s.upcase
      end

      def url
        @response.url.to_s
      end

      def headers
        JSON::pretty_generate(
          request: sanitized_request_headers,
          response: @response.response_headers
        )
      rescue => e
        "[Unable to show headers: #{e}]"
      end

      def errors
        parsed_body = JSON::parse(@body)
        JSON::pretty_generate(parsed_body["errors"] || parsed_body)
      rescue
        @body
      end

      def status_message
        HTTP_STATUS_CODES.fetch(status, 'UNKNOWN STATUS')
      end

      def sanitized_request_headers
        return request_headers unless request_headers['Authorization']
        request_headers.merge('Authorization' => truncated_authorization_value)
      end

      def request_headers
        @response.request_headers
      end

      def truncated_authorization_value
        bearer, token = request_headers['Authorization'].split(/\s+/)
        token_parts = token.split('~')
        token_parts[-1] = token_parts.last[0, 4]
        "Bearer #{token_parts.join('~')}..."
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

  # Every standard HTTP code mapped to the appropriate message. Ripped directly from
  # the Rack::Utils source :-)
  HTTP_STATUS_CODES = {
    100 => 'Continue',
    101 => 'Switching Protocols',
    102 => 'Processing',
    200 => 'OK',
    201 => 'Created',
    202 => 'Accepted',
    203 => 'Non-Authoritative Information',
    204 => 'No Content',
    205 => 'Reset Content',
    206 => 'Partial Content',
    207 => 'Multi-Status',
    208 => 'Already Reported',
    226 => 'IM Used',
    300 => 'Multiple Choices',
    301 => 'Moved Permanently',
    302 => 'Found',
    303 => 'See Other',
    304 => 'Not Modified',
    305 => 'Use Proxy',
    307 => 'Temporary Redirect',
    308 => 'Permanent Redirect',
    400 => 'Bad Request',
    401 => 'Unauthorized',
    402 => 'Payment Required',
    403 => 'Forbidden',
    404 => 'Not Found',
    405 => 'Method Not Allowed',
    406 => 'Not Acceptable',
    407 => 'Proxy Authentication Required',
    408 => 'Request Timeout',
    409 => 'Conflict',
    410 => 'Gone',
    411 => 'Length Required',
    412 => 'Precondition Failed',
    413 => 'Payload Too Large',
    414 => 'URI Too Long',
    415 => 'Unsupported Media Type',
    416 => 'Range Not Satisfiable',
    417 => 'Expectation Failed',
    421 => 'Misdirected Request',
    422 => 'Unprocessable Entity',
    423 => 'Locked',
    424 => 'Failed Dependency',
    426 => 'Upgrade Required',
    428 => 'Precondition Required',
    429 => 'Too Many Requests',
    431 => 'Request Header Fields Too Large',
    500 => 'Internal Server Error',
    501 => 'Not Implemented',
    502 => 'Bad Gateway',
    503 => 'Service Unavailable',
    504 => 'Gateway Timeout',
    505 => 'HTTP Version Not Supported',
    506 => 'Variant Also Negotiates',
    507 => 'Insufficient Storage',
    508 => 'Loop Detected',
    510 => 'Not Extended',
    511 => 'Network Authentication Required'
  }
end
