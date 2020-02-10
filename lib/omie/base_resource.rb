# frozen_string_literal: true

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

    def as_json
      data = {}

      instance_variables.each do |variable|
        name = variable.to_s.gsub('@', '')
        data[name] = self.send(name).as_json
      end

      data
    end

    def to_json
      as_json.to_json
    end
  end
end
