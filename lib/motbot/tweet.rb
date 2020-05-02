# frozen_string_literal: true

require "yaml"
require "pathname"
require "motbot/pretext"

module Motbot
  # Class that represents a tweet
  class Tweet
    # Thrown when loaded data is invalid
    class Error
      class InvalidTweet < StandardError; end
    end

    ACCESSORS = [:status, :possibly_sensitive, :media_files].freeze
    ACCESSORS.each { |a| attr_reader a }
    attr_reader :meta, :path, :lang

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
                format("must have tweet, is a hash: `%<file>s`", file: @path)
        end

        if t["tweet"].key?(a.to_s)
          instance_variable_set("@#{a}", t["tweet"][a.to_s])
        end
      end
      @meta = t["meta"]
      fixup_defaults
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
    def fixup_defaults
      @meta["sources"] = [] unless meta.key?("sources")
      @meta["lang"] = "en" unless meta.key?("lang")
      @media_files = [] if @media_files.nil?
      @status = @status.gsub("\n", " ")
    end

    # String of Twitter`status` to post
    def status_str
      str = format("%<pretext>s%<status>s %<sources>s",
                   pretext: Motbot::PreText.new(
                     lang: meta["lang"], timestamp: meta["timestamp"]
                   ).to_s,
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
