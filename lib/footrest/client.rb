require 'footrest/connection'
require 'footrest/request'

module Footrest
  class Client
    include Footrest::Connection
    include Footrest::Request

    attr_reader :config

    def initialize(options={}, &block)
      @config = Footrest.config.merge(options)
      set_connection(@config, &block)
    end
  end
end