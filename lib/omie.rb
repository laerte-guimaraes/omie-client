# frozen_string_literal: true

require_relative 'omie/base_resource'
require_relative 'omie/company'
require_relative 'omie/connection'
require_relative 'omie/error'
require_relative 'omie/info'
require_relative 'omie/version'

module Omie
  cattr_accessor :app_key, :app_secret
end
