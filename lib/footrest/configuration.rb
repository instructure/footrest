require 'faraday'
require 'active_support/configurable'

module Footrest
  include ActiveSupport::Configurable
  config_accessor :token
  config_accessor :prefix
  config_accessor :logging

  def configure
    yield self
  end
end

Footrest.configure do |config|
  config.token = nil
  config.prefix = nil
  config.logging = false
end
