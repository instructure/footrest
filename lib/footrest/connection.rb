require 'faraday'
require 'footrest/http_error'
require 'footrest/pagination'
require 'footrest/follow_redirects'
require 'footrest/parse_json'

module Footrest
  module Connection

    attr_reader :connection

    def set_connection(config)
      config[:logger] = config[:logging] if config[:logging]
      @connection = Faraday.new(url: config[:prefix]) do |faraday|
        faraday.request                     :multipart
        faraday.request                     :url_encoded
        if config[:logger] == true
          faraday.response :logger
        elsif config[:logger]
          faraday.use Faraday::Response::Logger, config[:logger]
        end
        faraday.use                         Footrest::FollowRedirects
        faraday.use                         Footrest::ParseJson, :content_type => /\bjson$/
        faraday.use                         Footrest::RaiseFootrestErrors
        faraday.use                         Footrest::Pagination
        faraday.headers[:accept]          = "application/json"
        faraday.headers[:authorization]   = "Bearer #{config[:token]}" if config[:token]
        faraday.headers[:user_agent]      = "Footrest"
        faraday.adapter                     Faraday.default_adapter
      end
    end

  end
end
