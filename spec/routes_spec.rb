require_relative '../app'
require 'rack/test'
require_relative '../lib/cowsay_characters'

RSpec.describe 'Cowsay App Routes', type: :request do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /' do
    it 'returns a successful response' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe 'GET /cowsay_output' do
    context 'when the request is valid' do
      let(:params) { { 'message' => 'Hello, world!', 'character' => 'tux' } }

      it 'returns a successful response' do
        get '/cowsay_output', params
        expect(last_response).to be_ok
      end
    end

    context 'when the request is invalid' do
      let(:params) { { 'message' => '', 'character' => 'invalid_character' } }

      it 'returns an error response' do
        post '/cowsay_output', params
        expect(last_response).not_to be_ok
      end
    end
  end
end
