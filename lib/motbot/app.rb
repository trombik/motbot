# frozen_string_literal: true

require "logger"
require "yaml"
require "time"
require "find"
require "twitter"
require "motbot/tweet"

# the Applicartion
module Motbot
  # the standard error class for Motbot
  class Error < StandardError; end

  # The application class
  class App
    def initialize
      @logger = Logger.new(STDOUT, level: :info)
      @logger.progname = "Motbot::App"
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        # config.bearer_token        = ENV["TWITTER_BEARER_TOKEN"]

        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
      end
      @config = load_config
      @tweets = []
      @now = time_now
    end

    def time_now
      Time.now
    end

    def load_config
      @config unless @config.nil?
      @config = YAML.load_file("config.yml")
    end

    # Post tweets.
    def run
      load_tweets(@config["assets"]["tweet"]["path"]).each do |tweet|
        update_with_media(tweet) if tweet.media_files
      end
    end

    # Post a tweet with media
    #
    # @param <Motbot::Tweet> A tweet
    def update_with_media(tweet)
      media = tweet.media_files.map { |file| File.new("#{@config['assets']['media']['path']}/#{file}") }
      @client.update_with_media(Time.now.to_i.to_s + " " + tweet.status, media)
    end

    # Load YAML files under configured path
    #
    # @param [String] path Path to tweet directory
    # @return [Array<Motbot::Tweet>]
    #
    def load_tweets(path)
      tweets = []
      Find.find(path) do |f|
        next if FileTest.directory?(f) || f !~ /\.yml$/

        begin
          tweet = Motbot::Tweet.new(f)
        rescue StandardError => e
          @logger.warn("failed to load a tweet from file: #{f}: #{e}")
          next
        end
        tweets << tweet
      end
      tweets
    end

    # Compare the timestamp of a tweet and today. if the date matches the
    # current day, returns true.
    #
    # @param <Motbot::Tweet>
    # @return true or false
    def today?(tweet)
      tweet.timestamp.month == @now.month && tweet.timestamp.day == @now.day
    end
  end
end
