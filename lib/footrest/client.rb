require 'footrest/connection'
require 'footrest/request'

module Footrest
  class Client
    attr_reader :options

    include Footrest::Connection
    include Footrest::Request

    def initialize(options={}, &block)
      @options = Footrest.config.merge(options)
      @faraday_option_block = block
    end
  end
end