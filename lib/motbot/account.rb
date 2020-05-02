# frozen_string_literal: true

require "twitter"

module Motbot
  # Account that represents Twitter account to post tweets to.
  class Account
    attr_reader :secret, :token, :lang, :client

    def initialize(args)
      @secret = args[:secret]
      @token = args[:token]
      @lang = args[:lang]
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        # config.bearer_token        = ENV["TWITTER_BEARER_TOKEN"]
        config.access_token        = @token
        config.access_token_secret = @secret
      end
    end
  end
end
