# frozen_string_literal: true

require "pathname"
require "yaml"

module Motbot
  class Config < Hash
    def initialize(path = Pathname.pwd + "config.yml")
      @path = path
      @config = load_config(@path)
    end

    def load_config(path)
      YAML.load_file(path)
    end

    def config
      @config
    end
  end
end
