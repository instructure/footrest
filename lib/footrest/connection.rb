require 'faraday'
require 'faraday_middleware'
require 'faraday/response/raise_footrest_http_error'

module Footrest
  module Connection

    def connection(options = {})
      auth_token = options.delete(:token) || @token
      host = options.delete(:domain) || @domain

      @connection ||= Faraday.new(url: host) do |faraday|
        faraday.request                     :multipart
        faraday.request                     :url_encoded
        faraday.response                    :logger
        faraday.adapter                     Faraday.default_adapter
        faraday.use                         FaradayMiddleware::FollowRedirects
        faraday.use                         FaradayMiddleware::ParseJson, :content_type => /\bjson$/
        faraday.use                         Faraday::Response::RaiseFootrestHttpError
        faraday.headers[:accept] =          "application/json"
        faraday.headers[:authorization] =   "Bearer #{auth_token}"
      end
    end

  end
end