# frozen_string_literal: true

module Omie
  # This is the base Omie exception class. Rescue it if you want to catch
  # any exceptions that your request might raise. In addition to the
  # message, it may receive the response, a RestClient::Response object
  # that can be used to improve the error messages.
  class Error < RuntimeError
    attr_accessor :message, :response

    # Initialize the exception with the message and the request's response and
    # call the {#after_initialize} callback
    def initialize(message = nil, response = nil)
      @message = message
      @response = response
      after_initialize
    end

    # Callback to be overridden by underlying classes
    def after_initialize; end
  end

  # This exception must be used for failed requests with JSON responses
  # from Omie.
  #
  # Omie does not use the semantic value of HTTP status codes. It always
  # returns the 500 error code to any failed request that has an associated
  # message to the client, which was supposed to use the 400* error codes.
  # Moreover, the error message is provided through a returned JSON object
  # that has the keys 'faultstring' and 'faultcode'. Such data is
  # used in the exception message for a better understanding of the error.
  class RequestError < Omie::Error
    # Sets fault_string and fault_code based on Omie's responses for failed
    # requests.
    def after_initialize
      return unless @response

      json = JSON.parse(@response.body)
      @fault_string = json['faultstring']
      @fault_code = json['faultcode']
    end

    # Return the custom message or a default message with the fault code and
    # string.
    def message
      @message || default_message
    end

    def default_message
      "Omie returned the error #{@fault_code}: '#{@fault_string}'"
    end
  end

  # One may use this exception when a request produces a HTTP status codes
  # different from *500*
  class InvalidResponseError < Omie::Error
  end

  # This exception is used when the Omie credentials are not set.
  #
  # See {Omie.app_key} and {Omie.app_secret} for more details.
  class MissingCredentialsError < Omie::Error
  end
end
