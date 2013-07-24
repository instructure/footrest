require 'footrest/connection'
require 'footrest/request'

module Footrest
  class Client
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    def initialize(options={})
      options = Footrest.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Footrest::Connection
    include Footrest::Request

  end
end