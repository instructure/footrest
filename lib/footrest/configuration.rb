require 'faraday'
require 'active_support/configurable'

module Footrest
  include ActiveSupport::Configurable
  config_accessor :token
  config_accessor :domain
  config_accessor :path_prefix

  def configure
    yield self
  end
end