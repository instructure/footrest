require 'footrest/connection'
require 'footrest/request'
require 'active_support/ordered_options'

module Footrest
  class Client
    include Footrest::Connection
    include Footrest::Request

    # Well-known options surfaced as reader/writer methods (e.g. client.token).
    # Any other option remains reachable through #config (e.g. config[:domain]).
    CONFIG_ACCESSORS = %i[token prefix logging].freeze

    def initialize(options={}, &block)
      config.merge!(options)
      yield self if block_given?
      set_connection(config)
    end

    # Per-instance options bag. ActiveSupport::OrderedOptions supports both
    # hash-style (config[:token]) and method-style (config.token) access, the
    # same surface ActiveSupport::Configurable's config object provided. This
    # replaces `include ActiveSupport::Configurable`, which activesupport
    # deprecates in 8.1 and removes in 8.2.
    def config
      @config ||= ActiveSupport::OrderedOptions.new
    end

    CONFIG_ACCESSORS.each do |name|
      define_method(name) { config[name] }
      define_method("#{name}=") { |value| config[name] = value }
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