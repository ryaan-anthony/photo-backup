#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'bootstrap'
TIME_REMAINING = ->(time) { ((60 * 55) - (Time.now - time)).to_i }

loop do
  App.logger.info 'Starting...'
  start = Time.now
  access_token = Google::AccessToken.new.refresh
  raise 'Invalid access_token' if access_token.nil?

  photos_client = Google::Photos.new(access_token)
  storage = Google::Cloud::Storage.new

  last_run = Time.parse(File.read('last_run.txt'))
  File.write('last_run.txt', Time.now)

  # Copy all files not already backed up and mark them
  ListPhotos.new(photos_client).each do |photo|
    timestamp = Time.parse(photo['mediaMetadata']['creationTime'])

    raise BreakLoop, 'no new photos' if last_run > timestamp
    raise BreakLoop, 'out of time' if TIME_REMAINING.call(start) < 0

    App.logger.debug "Time remaining #{TIME_REMAINING.call(start)} seconds"
    begin
      action = photo['mimeType'].include?('video') ? 'dv' : 'd'
      URI.open("#{photo['baseUrl']}=#{action}") do |file|
        year = timestamp.strftime('%Y')
        month = timestamp.strftime('%m')
        App.logger.debug "Backing up #{year}/#{month}/#{photo['filename']}"
        bucket = storage.bucket ENV.fetch('STORAGE_BUCKET')
        bucket.create_file file, "#{year}/#{month}/#{photo['filename']}"
      end
    rescue StandardError => e
      App.logger.debug "Asset Exception #{photo['filename']}"
      App.logger.error e.message
      Sentry.capture_exception(e)
    end
  end

rescue BreakLoop => e
  App.logger.debug e.message

rescue StandardError => e
  App.logger.debug 'Application Exception'
  App.logger.error e.message
  Sentry.capture_exception(e)

ensure
  next_run = TIME_REMAINING.call(start)
  next_run = next_run > 0 ? next_run : 0
  App.logger.info "Next run in #{next_run} seconds"

  sleep next_run
end