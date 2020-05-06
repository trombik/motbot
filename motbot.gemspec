# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "motbot/version"
require 'rbconfig'

Gem::Specification.new do |spec|
  spec.name          = "motbot"
  spec.version       = Motbot::VERSION
  spec.authors       = ["Tomoyuki Sakurai"]
  spec.email         = ["y@trombik.org"]

  spec.summary       = "The bot tweets historical events in Thailand"
  spec.description   = "The bot tweets historical events on the date, and " \
                       "time where available, they happened"
  spec.homepage      = "https://github.com/trombik/motbot"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/trombik/motbot"
  spec.metadata["changelog_uri"] = "https://github.com/trombik/motbot/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.  The
  # `git ls-files -z` loads the files in the RubyGem that have been added into
  # git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "twitter", "~> 7.0"
  spec.add_runtime_dependency "twitter-text", "~> 3.1.0"
  spec.add_runtime_dependency "omniauth-twitter", "~> 1.4.0"
  spec.add_runtime_dependency "sinatra", "~> 2.0.8"
  spec.add_runtime_dependency "rchardet", "~> 1.8.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "rubocop", "~> 0.82.0"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
