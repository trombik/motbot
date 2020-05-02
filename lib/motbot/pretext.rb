# frozen_string_literal: true

require "time"

module Motbot
  # Pre-text for tweets.
  class PreText
    def initialize(args)
      @lang = args[:lang]
      @timestamp = Time.parse(args[:timestamp].to_s)
    end

    def to_s
      validate
      prefix_str
    end

    def time_now
      Time.now
    end

    SUPPRTED_LANGUAGE = %w[en ja].freeze
    L10N_OF = {
      "today" => {
        "en" => "Today",
        "ja" => "今日"
      },
      "last_year_today" => {
        "en" => "Last year today",
        "ja" => "去年の今日"
      },
      "n_years_ago_today" => {
        "en" => "%<when>s years ago today",
        "ja" => "%<when>s年前の今日"
      }
    }.freeze

    private

    # Generate prefix string
    #
    def prefix_str
      how_many_year = time_now.year - @timestamp.year
      if how_many_year.zero?
        L10N_OF["today"][@lang] + ": "
      elsif how_many_year == 1
        L10N_OF["last_year_today"][@lang] + ": "
      else
        format(L10N_OF["n_years_ago_today"][@lang], when: how_many_year) + ": "
      end
    end

    def validate
      raise ArgumentError if @lang.nil? || @timestamp.nil?
      raise Error::UnsupportedLanguage unless SUPPRTED_LANGUAGE.include?(@lang)

      SUPPRTED_LANGUAGE.each do |l|
        L10N_OF.each_key do |key|
          raise Error::MissingL10N unless L10N_OF[key].key?(l)
        end
      end
    end

    class Error < StandardError
      # thrown when the language is not supported
      class UnsupportedLanguage < Error
      end

      # thrown when L10N_OF does not have necessary l10n text
      class MissingL10N < Error
        def message
          "BUG: #{__FILE__} has missing l10n in L10N_OF"
        end
      end
    end
  end
end
