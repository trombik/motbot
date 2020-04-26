# frozen_string_literal: true

require "logger"
require "yaml"
require "time"
require "find"
require "motbot/client"
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
      @client = Motbot::Client.new
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

    # initialize an instance of Motbot
    def run
      @logger.info "Hello world"
      @logger.info "Loading tweets from #{@config['assets']['tweet']['path']}"
      tweets = load_tweets(@config["assets"]["tweet"]["path"])
      @logger.info "Loaded tweets: #{tweets.length}"
      @logger.info "Good bye world"
    end

    # Load YAML files under configured path
    #
    # @param [String] path Path to tweet directory
    # @return [Array<Motbot::Tweet>]
    #
    # rubocop:disable Metrics/MethodLength
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
    # rubocop:enable Metrics/MethodLength

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
