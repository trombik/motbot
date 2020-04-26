# frozen_string_literal: true

require "twitter"

module Motbot
  # Thin wrapper of Twitter::REST::Client
  class Client
    def initialize
      Twitter::REST::Client.new do |config|
        config.bearer_token = ENV["TWITTER_BEARER_TOKEN"]
      end
    end
  end
end
