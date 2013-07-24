require 'faraday'

module Footrest
  module Configuration
    VALID_OPTIONS_KEYS = [
      :token,
      :domain,
      :path_prefix
    ].freeze

    attr_accessor(*VALID_OPTIONS_KEYS)

    def options
      VALID_OPTIONS_KEYS.inject({}) { |o, k| o.merge!(k => send(k)) }
    end

  end
end