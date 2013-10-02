require 'faraday'
require 'faraday_middleware'
require 'footrest/http_error'
require 'footrest/pagination'

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
        faraday.use                         Footrest::RaiseFootrestErrors
        faraday.use                         Footrest::Pagination
        faraday.headers[:accept]          = "application/json"
        faraday.headers[:authorization]   = "Bearer #{config[:token]}" if config[:token]
        faraday.headers[:user_agent]      = "Footrest"
      end
    end

  end
end