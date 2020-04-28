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
      @logger.info("Starting")
      load_tweets(@config["assets"]["tweet"]["path"]) \
        .select { |t| enabled_and_today?(t) } \
        .each do |tweet|
        begin
          @logger.info("posting tweet #{tweet.status[0, 20]}")
          post(tweet)
        rescue StandardError => e
          @logger.warn("#{e}\n#{e.backtrace}")
          next
        end
      end
    end

    def post(tweet)
      !tweet.media_files.empty? ? update_with_media(tweet) : update_without_media(tweet)
    end

    # Post a tweet without media
    #
    # @param <Motbot::Tweet>
    def update_without_media(tweet)
      status = prefix_str(tweet) + tweet.status_str
      @client.update(status)
      sleep 60
    end

    # Post a tweet with media
    #
    # @param <Motbot::Tweet> A tweet
    def update_with_media(tweet)
      media = tweet.media_files.map { |file| File.new("#{@config['assets']['media']['path']}/#{file}") }
      status = prefix_str(tweet) + tweet.status_str
      @client.update_with_media(status, media)
      sleep 60
    end

    # Generate prefix string from a tweet
    #
    # @param <Motbot::Tweet> A tweet
    def prefix_str(tweet)
      how_many_year = time_now.year - tweet.meta["timestamp"].year
      if how_many_year.zero?
        "Today: "
      elsif how_many_year == 1
        "Last year today: "
      else
        "#{how_many_year.to_s.reverse.scan(/\d{3}|.+/).join(',').reverse} years ago today: "
      end
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
          @logger.warn("failed to load a tweet from file: #{f}: #{e}\n#{e.backtrace}")
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
      tweet.meta["timestamp"].month == @now.month && tweet.meta["timestamp"].day == @now.day
    end

    # Whether or not the tweet is disabled
    #
    # @param <Motbot::Tweet>
    # @return true or false
    def disabled?(tweet)
      tweet.meta.key?("state") && tweet.meta["state"] == "disabled"
    end

    def enabled_and_today?(tweet)
      !disabled?(tweet) && today?(tweet)
    end
  end
end
