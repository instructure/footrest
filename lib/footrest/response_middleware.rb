require 'faraday'

module Footrest
  # Internal: The base class for middleware that parses responses.
  class ResponseMiddleware < Faraday::Middleware
    CONTENT_TYPE = 'Content-Type'.freeze

    class << self
      attr_accessor :parser
    end

    # Store a Proc that receives the body and returns the parsed result.
    def self.define_parser(parser = nil, &block)
      @parser = parser || block
    end

    def self.inherited(subclass)
      super
      subclass.load_error = self.load_error if subclass.respond_to? :load_error=
      subclass.parser = self.parser
    end

    def initialize(app = nil, options = {})
      super(app)
      @options = options
      @content_types = Array(options[:content_type])
    end

    def call(environment)
      @app.call(environment).on_complete do |env|
        if process_response_type?(response_type(env)) and parse_response?(env)
          process_response(env)
        end
      end
    end

    def process_response(env)
      env[:body] = parse(env[:body])
    end

    # Parse the response body.
    #
    # Instead of overriding this method, consider using `define_parser`.
    def parse(body)
      if self.class.parser
        begin
          self.class.parser.call(body)
        rescue StandardError, SyntaxError => err
          raise err if err.is_a? SyntaxError and err.class.name != 'Psych::SyntaxError'
          raise Faraday::ParsingError, err
        end
      else
        body
      end
    end

    def response_type(env)
      if env[:response_headers]
        type = env[:response_headers][CONTENT_TYPE].to_s
        type = type.split(';', 2).first if type.index(';')
        type
      else
        warn("response_headers are nil. Did you use http when you meant https?")
        nil
      end
    end

    def process_response_type?(type)
      @content_types.empty? or @content_types.any? { |pattern|
        pattern.is_a?(Regexp) ? type =~ pattern : type == pattern
      }
    end

    def parse_response?(env)
      env[:body].respond_to? :to_str
    end
  end
end