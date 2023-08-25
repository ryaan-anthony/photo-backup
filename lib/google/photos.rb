# frozen_string_literal: true

require 'faraday'

module Google
  class Photos
    attr_reader :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    def list(page_token = nil)
      process client.get('v1/mediaItems', pageSize: 100, pageToken: page_token)
    end

    def update(id, options)
      client.patch("v1/mediaItems/#{id}", options)
    end

    private

    def process(response)
      JSON.parse(response.body)
    end

    def client
      Faraday.new(url: 'https://photoslibrary.googleapis.com', headers: headers)
    end

    def headers
      {
        'Authorization' => "Bearer #{access_token}",
        'Content-Type' => 'application/json'
      }
    end
  end
end
