# frozen_string_literal: true

require "logger"
require "yaml"
require "time"
require "find"
require "twitter"
require "motbot/tweet"
require "motbot/validator"
require "motbot/account"

# the Applicartion
module Motbot
  # the standard error class for Motbot
  class Error < StandardError; end

  # The application class
  class App
    def initialize
      @logger = Logger.new(STDOUT, level: :info)
      @logger.progname = "Motbot::App"
      @config = load_config
      @tweets = []
      @now = time_now
      @accounts = []
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
        accounts.each do |account|
          begin
            @logger.info("posting tweet #{tweet.path}")
            post(account, tweet)
          rescue StandardError => e
            @logger.warn("#{e}\n#{e.backtrace}")
            next
          end
        end
      end
    end

    def accounts
      return @accounts unless @accounts.empty?

      tokens = ENV["TWITTER_ACCESS_TOKENS"].split(/\s+/)
      secrets = ENV["TWITTER_ACCESS_SECRETS"].split(/\s+/)
      tokens.each_with_index do |val, index|
        @accounts << Motbot::Account.new(token: val, secret: secrets[index])
      end
      @accounts
    end

    def post(account, tweet)
      if !tweet.media_files.empty?
        update_with_media(account, tweet)
      else
        update_without_media(account, tweet)
      end
    end

    # Post a tweet without media
    #
    # @param <Motbot::Tweet>
    def update_without_media(account, tweet)
      status = prefix_str(tweet) + tweet.status_str
      account.client.update(status)
      sleep 60
    end

    # Post a tweet with media
    #
    # @param <Motbot::Tweet> A tweet
    def update_with_media(account, tweet)
      media = tweet.media_files.map do |file|
        File.new("#{@config['assets']['media']['path']}/#{file}")
      end
      status = prefix_str(tweet) + tweet.status_str
      account.client.update_with_media(status, media)
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
        format("%<when>s years ago today: ",
               when: how_many_year.to_s.reverse.scan(/\d{3}|.+/) \
                                  .join(",").reverse)
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
          tweet = validate(Motbot::Tweet.new(f))
        rescue StandardError => e
          @logger.warn("failed to load from file: #{f}: #{e} #{e.message}")
          raise e if ENV["MOTBOT_STRICT_VALIDATION"]

          next
        end
        tweets << tweet
      end
      tweets
    end

    def validate(tweet)
      @validator = Motbot::Validator.new
      @validator.validate_tweet(tweet)
    end

    # Compare the timestamp of a tweet and today. if the date matches the
    # current day, returns true.
    #
    # @param <Motbot::Tweet>
    # @return true or false
    def today?(tweet)
      tweet.meta["timestamp"].month == @now.month &&
        tweet.meta["timestamp"].day == @now.day
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
