require 'footrest/connection'
require 'footrest/request'

module Footrest
  class Client
    attr_reader :options

    include Footrest::Connection
    include Footrest::Request

    def initialize(options={})
      @options = Footrest.config.merge(options)
    end
  end
end