# frozen_string_literal: true

require 'faraday'

module Google
  class AccessToken
    def refresh
      response['access_token']
    end

    private

    def client
      Faraday.new(url: 'https://www.googleapis.com')
    end

    def response
      process client.post('oauth2/v3/token', request.body)
    end

    def process(response)
      JSON.parse(response.body)
    end

    def request
      Requests::RefreshToken.new
    end
  end
end