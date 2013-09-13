require 'faraday'
require 'faraday_middleware'
require 'faraday/response/raise_footrest_http_error'

module Footrest
  module Connection

    attr_reader :connection

    def set_connection(config)
      @connection = Faraday.new(url: config[:prefix]) do |faraday|
        faraday.request                     :multipart
        faraday.request                     :url_encoded
        faraday.response                    :logger if config[:logging]
        faraday.adapter                     Faraday.default_adapter
        faraday.use                         FaradayMiddleware::FollowRedirects
        faraday.use                         FaradayMiddleware::ParseJson, :content_type => /\bjson$/
        faraday.use                         Faraday::Response::RaiseFootrestHttpError
        faraday.headers[:accept]          = "application/json"
        faraday.headers[:authorization]   = "Bearer #{config[:token]}" if config[:token]
        faraday.headers[:user_agent]      = "Footrest"
      end
    end

  end
end