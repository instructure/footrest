require 'faraday'
require 'faraday_middleware'
require 'faraday/response/raise_footrest_http_error'

module Footrest
  module Connection

    def connection
      @options ||= {}
      @connection ||= Faraday.new(url: @options[:domain]) do |faraday|
        faraday.request                     :multipart
        faraday.request                     :url_encoded
        # faraday.response                    :logger
        faraday.adapter                     Faraday.default_adapter
        faraday.use                         FaradayMiddleware::FollowRedirects
        faraday.use                         FaradayMiddleware::ParseJson, :content_type => /\bjson$/
        faraday.use                         Faraday::Response::RaiseFootrestHttpError
        faraday.headers[:accept] =          "application/json"
        faraday.headers[:authorization] =   "Bearer #{@options[:token]}"
        faraday.headers[:user_agent]    =   "Footrest"
      end
    end

  end
end