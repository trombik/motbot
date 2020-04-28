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
        unless t.key?("tweet") && t["tweet"].key?(a.to_s)
          raise Error::InvalidTweet, \
                "a tweet must have `tweet` at top level, and `tweet must have `#{a}`"
        end

        instance_variable_set("@#{a}", t["tweet"][a.to_s])
      end
      @meta = t["meta"]
      validate
      @status = @status.gsub("\n", " ")
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
      raise Error::InvalidTweet unless timestamp? && valid_media_files?
    end

    # String of Twitter`status` to post
    def status_str
      # XXX include Unix time so that same tweet can be posted during
      # development
      str = format("#{Time.now.to_i} %<status>s %<sources>s",
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
