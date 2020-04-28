# frozen_string_literal: true

require "yaml"
require "pathname"
require "motbot/tweetrules"

module Motbot
  # Class that represents a tweet
  class Tweet
    # Thrown when loaded data is invalid
    class Error
      class InvalidTweet < StandardError; end
    end

    include Motbot::TweetRules

    ACCESSORS = [:status, :possibly_sensitive, :media_files].freeze
    ACCESSORS.each { |a| attr_reader a }
    attr_reader :meta

    # The constructor.
    #
    # @param path Path to YAML file of the tweet
    #
    def initialize(path)
      @path = path
      t = load_yaml(@path)
      ACCESSORS.each do |a|
        unless t.key?("tweet") && t["tweet"].is_a?(Hash)
          raise Error::InvalidTweet,
                format("a tweet must have `tweet` at top level, and it is a hash: `%<file>s`",
                       file: @path)
        end

        if t["tweet"].key?(a.to_s)
          instance_variable_set("@#{a}", t["tweet"][a.to_s])
        end
      end
      @meta = t["meta"]
      validate
    end

    def config
      return @config if @config

      @config = load_config
    end

    def load_config
      load_yaml("config.yml")
    end

    # Load YAML file and returns a hash.
    #
    # @param Path to YAML file of the tweet
    #
    def load_yaml(path)
      YAML.load_file(path)
    end

    # Validate the instance, and raise Tweet::Error if the tweet is invalid
    #
    def validate
      @meta["sources"] = [] unless meta.key?("sources")
      @media_files = [] if @media_files.nil?
      unless timestamp? && valid_media_files? && status?
        raise Error::InvalidTweet
      end

      @status = @status.gsub("\n", " ")
    end

    # String of Twitter`status` to post
    def status_str
      str = format("%<status>s %<sources>s",
                   status: status,
                   sources: meta["sources"].join(" "))
      str.strip
    end

    # Returns whether of not the tweet is disabled
    def disabled?
      meta.key?("state") && meta["state"] == "disabled"
    end
  end
end
