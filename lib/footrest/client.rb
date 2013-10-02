require 'footrest/connection'
require 'footrest/request'
require 'active_support/configurable'

module Footrest
  class Client
    include Footrest::Connection
    include Footrest::Request
    include ActiveSupport::Configurable

    config_accessor :token
    config_accessor :prefix
    config_accessor :logging

    def initialize(options={}, &block)
      self.config.merge!(options)
      yield self if block_given?
      set_connection(config)
    end

    def connection(&block)
      @connection.tap do |conn|
        yield conn if block_given?
      end
    end

    def fullpath(path)
      return path if path =~ /^https?:/i
      prefix ? join(prefix, path) : path
    end

  protected
    def join(*parts)
      joined = parts.map{ |p| p.gsub(%r{^/|/$}, '') }.join('/')
      joined = '/' + joined if parts.first[0] == '/'
      joined
    end
  end
end