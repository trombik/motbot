# frozen_string_literal: true

require "yaml"

module Motbot
  # Class that represents a tweet
  class Tweet
    # Standard error in this class
    class Error < StandardError; end

    ACCESSORS = [:status, :possibly_sensitive, :media_files, :timestamp]
    ACCESSORS.each { |a| attr_accessor a }

    # The constructor.
    #
    # @param path Path to YAML file of the tweet
    #
    def initialize(path)
      @path = path
      t = load_yaml(@path)
      t.each_key do |key|
        instance_variable_set("@#{key}", t[key])
      end
      validate
    end

    # Load YAML file and returns a hash.
    #
    # @param Path to YAML file of the tweet
    #
    def load_yaml(path)
      YAML.load_file(path).transform_keys(&:to_sym)
    end

    # Validate the instance, and raise Tweet::Error if the tweet is invalid
    #
    def validate
      return true if !timestamp.nil? && !status.nil?

      raise Motbot::Tweet::Error,
            format("timestamp and status are required: %<path>s", path: @path)
    end
  end
end
