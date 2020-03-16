# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'active_support/json'

module Omie
  # This class contains all logic shared among available resources.
  class BaseResource
    # Initialize the object based on a Hash of attributes their respective
    # values
    def initialize(args = {})
      args.each do |key, value|
        send("#{key}=", value) if respond_to?(key)
      end
    end

    # Update the object with the informed attributes passed as a Hash
    def update_attributes(args = {})
      args.each do |key, value|
        send("#{key}=", value) if respond_to?(key)
      end
    end

    def self.request(uri, call, params)
      Omie::Connection.request(uri, call, params)
    end

    def self.request_and_initialize(uri, call, params)
      response = request(uri, call, params)
      new(response)
    end
  end
end
