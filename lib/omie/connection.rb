# frozen_string_literal: true

require 'rest-client'
require 'json'

module Omie
  # This class is used internally to send HTTP requests to Omie API based
  # on RestClient gem. It is responsible for parsing JSON to Hash objects
  # and handle errors.
  class Connection
    API_URI = 'https://app.omie.com.br/api' # Base URL for Omie API

    # Perform a request to Omie API based on params. It does not make any
    # kind of manipulation, and validation of such params. Rather, it only
    # abstracts the interaction with the API, parsing the response or handling
    # possible errors.
    #
    # @!scope class
    # @param url [String]
    #   the url path to the resource. It is appended in the end of
    #   {Omie::Connection::API_URI}.
    # @param call [String]
    #   the OMIE_CALL parameter that defines which resource is being
    #   requested. The Omie API defines endpoint based on this parameter
    #   instead of HTTP methods and URI.
    # @param payload_to_request [Hash]
    #   the hash corresponding to the JSON payload of the request.
    #
    # @raise [Omie::RequestError]
    #   in case of a client error returned by the API through JSON payloads
    # @raise [Omie::InvalidResponseError]
    #   in case of errors with unhandled responses
    #
    # @return [Hash]
    #   the response JSON parsed
    def self.request(url, call, payload_to_request = {})
      payload = create_payload(call, payload_to_request)

      response = RestClient::Request.new(
        method: :post,
        url: API_URI + url,
        payload: payload,
        headers: { content_type: :json }
      ).execute

      JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      Omie::Connection.handle_error_with_response(e.response)
    end

    # Create the payload of the request with the credentials, the specific call
    # and the payload data.
    #
    # @raise [Omie::MissingCredentialsError]
    #   when either {Omie.app_key} or {Omie.app_secret} is blank
    #
    # @return [String]
    #   a string in JSON format ready to be used as the payload of requests
    #   to Omie API.
    def self.create_payload(call, data = {})
      if Omie.app_key.blank? || Omie.app_secret.blank?
        raise Omie::MissingCredentialsError,
              'Omie.app_key and Omie.app_secret cannot be blank'
      end

      payload_request = {
        app_key: Omie.app_key,
        app_secret: Omie.app_secret,
        call: call,
        param: [data]
      }

      payload_request.to_json
    end

    # Handle errors with a response from Omie API by raising custom exceptions.
    # The API does not use the HTTP
    # status codes appropriately since it always returns error 500 for all
    # kind of known errors (client errors). Moreover, the specific details of
    # the error are described in the returned JSON. See {Omie::RequestError} for
    # more details.
    #
    # @raise [Omie::RequestError]
    #   in case of documented error from Omie API (with status code 500)
    #   since it displays the error message returned by Omie API.
    # @raise [Omie::InvalidResponseError]
    #   in case of errors with status code different from 500
    def self.handle_error_with_response(response)
      raise Omie::RequestError.new(nil, response) if response.code == 500

      raise Omie::InvalidResponseError, "Invalid response received: #{response}"
    end
  end
end
