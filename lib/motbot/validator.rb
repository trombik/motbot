# frozen_string_literal: true

require "yaml"
require "pathname"
require "twitter-text"

module Motbot
  # A clas that validate a tweet object
  class Validator
    include Twitter::TwitterText::Validation
    MAX_TWEET_LENGTH = 280

    def validate_tweet(tweet)
      valid?(tweet)
      timestamp?(tweet)
      authors?(tweet)
      valid_media_files?(tweet)
      status?(tweet)
      valid_sources?(tweet)
    end

    def valid?(tweet)
      status_str = "XXX years ago today: " + tweet.status_str
      r = parse_tweet(status_str)
      return true if r[:valid]

      if r[:weighted_length] > MAX_TWEET_LENGTH
        raise Error::TweetTooLong, \
              format("remove %<len>d character(s)",
                     len: r[:weighted_length] - MAX_TWEET_LENGTH)
      end
      raise Error::Unknown
    end

    def timestamp?(tweet)
      raise Error::MissingTimestamp unless tweet.meta.key?("timestamp")
      raise Error::MissingTimestamp if tweet.meta["timestamp"].nil?
      raise Error::MissingTimestamp if tweet.meta["timestamp"].to_s.empty?
    end

    def authors?(tweet)
      meta = tweet.meta
      raise Error::MissingAuthors unless tweet.meta.key?("authors")
      raise Error::MissingAuthors unless tweet.meta["authors"].is_a?(Array)
      raise Error::MissingAuthors if tweet.meta["authors"].empty?

      meta["authors"].each do |a|
        raise Error::InvalidAuthor unless a.is_a?(String)
      end
    end

    def config
      load_config
    end

    def load_config
      load_yaml("config.yml")
    end

    def load_yaml(file)
      YAML.load_file(file)
    end

    def valid_media_files?(tweet)
      raise Error::TooManyMediaFiles if tweet.media_files.length > 4

      tweet.media_files.each do |f|
        file = Pathname.new(config["assets"]["media"]["path"]) + f
        next if file.exist? && file.file? && file.readable?

        raise Error::InvalidMediaFiles, \
              format("%<file>s must exist, be a file, and be readable",
                     file: file)
      end
      true
    end

    def status?(tweet)
      raise Error::MissingStatus unless tweet.status
      raise Error::MissingStatus if tweet.status.length.zero?
    end

    def valid_sources?(tweet)
      raise Error::InvalidSources unless tweet.meta.key?("sources")
      raise Error::InvalidSources unless tweet.meta["sources"].is_a?(Array)

      tweet.meta["sources"].each do |s|
        raise Error::InvalidSources unless s.is_a?(String)
      end
    end
  end

  # the base class of Error
  class Error < StandardError
    attr_accessor :message

    def initialize(message = nil)
      super()
      @message = message unless message.nil?
    end

    # thrown when unknown error happens
    class Unknown < Error
      def message
        "BUG: Unknown error"
      end
    end

    class InvalidMediaFiles < Error
    end

    class TweetTooLong < Error
    end

    # thrown when a tweet does not have status
    class MissingStatus < Error
      def message
        "tweet does not have status"
      end
    end

    class MissingTimestamp < Error
    end

    class MissingAuthors < Error
    end

    class InvalidAuthor < Error
    end

    class TooManyMediaFiles < Error
    end

    class InvalidSources < Error
    end
  end
end
