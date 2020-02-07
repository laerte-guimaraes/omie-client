# frozen_string_literal: true

describe Omie::Connection do
  let(:custom_response) { RestClient::Response.new }

  before do
    Omie.app_key = 'APP_KEY'
    Omie.app_secret = 'APP_SECRET'
  end

  describe '.request' do
    it 'raises exception if Omie app_key is blank' do
      Omie.app_key = nil
      expect { described_class.request('', '') }
        .to raise_error(Omie::MissingCredentialsError)
    end

    it 'raises exception if Omie app_secret is blank' do
      Omie.app_secret = nil
      expect { described_class.request('', '') }
        .to raise_error(Omie::MissingCredentialsError)
    end

    it 'parses success response to JSON' do
      allow(custom_response).to receive(:code).and_return(200)
      allow(custom_response).to receive(:body).and_return('{}')
      allow_any_instance_of(RestClient::Request).to receive(:execute)
        .and_return(custom_response)

      response = described_class.request('/v1', 'EXAMPLE')
      expect(response).to eq({})
    end

    it 'parses errors with code 500' do
      allow(custom_response).to receive(:code).and_return(500)
      allow(custom_response).to receive(:body).and_return({
        'faultstring' => 'ERROR: Nenhum parâmetro foi recebido em WS_PARAMS!',
        'faultcode' => 'SOAP-ENV:Client-71'
      }.to_json)
      allow_any_instance_of(RestClient::Request).to receive(:execute)
        .and_raise(RestClient::ExceptionWithResponse.new(custom_response))

      expect { described_class.request('', '') }
        .to raise_error(Omie::RequestError)
    end

    it 'do not parses error code different from 500' do
      allow(custom_response).to receive(:code).and_return(404)
      allow_any_instance_of(RestClient::Request).to receive(:execute)
        .and_raise(RestClient::ExceptionWithResponse.new(custom_response))

      expect { described_class.request('', '') }
        .to raise_error(Omie::InvalidResponseError)
    end
  end
end
