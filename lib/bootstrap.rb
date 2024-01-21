# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path(__dir__)

# Instantiate logger
require 'logger'

# Require lib files
require 'google/cloud/storage'
require 'google/requests/refresh_token'
require 'google/access_token'
require 'google/photos'
require 'services/list_photos'
require 'sentry-ruby'
Sentry.init do |config|
  config.dsn = ENV.fetch('SENTRY_DSN')
end

class BreakLoop < StandardError; end
class App
  @logger = Logger.new('event.log')
  @logger.level = Logger::DEBUG

  def self.logger
    @logger
  end
end