# frozen_string_literal: true

module Motbot
  # Rules that a tweet must follow
  module TweetRules
    # Must have status
    def status?
      status
    end

    # Must have a timestamp
    def timestamp?
      if meta["timestamp"].nil? || meta["timestamp"].to_s.empty?
        warn "timestamp is required"
        return false
      end
      true
    end

    # Must have corresponding media files
    def valid_media_files?
      result = true
      media_files.each do |f|
        file = Pathname.new(config["assets"]["media"]["path"]) + f
        unless file.exist? && file.file? && file.readable?
          warn "#{file} in media_files must exist, be a file, and be readable"
          result = false
        end
      end
      result
    end
  end
end
