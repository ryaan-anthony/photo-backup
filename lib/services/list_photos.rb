# frozen_string_literal: true

class ListPhotos
  attr_reader :photos_client

  def initialize(photos_client)
    @photos_client = photos_client
  end

  def each(&block)
    page_token = nil
    loop do
      response = photos_client.list(page_token)
      response['mediaItems'].each do |item|
        block.call(item)
      end
      page_token = response['nextPageToken']

      App.logger.debug "Next: #{page_token}"
      break if page_token.nil?
    end
  end
end