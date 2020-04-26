# frozen_string_literal: true

# Generated by `infrataster init`

require "English"
require "rake"
require "rspec/core/rake_task"
require "find"
require "open3"

RSpec::Core::RakeTask.new(:spec)
task default: [:spec, "test:ci"]

# rubocop:disable Metrics/BlockLength:
namespace :test do
  namespace "ci" do
    task :rubocop do
      sh "rubocop --display-cop-names --display-style-guide --extra-details"
    end

    task :markdownlint do
      sh "node node_modules/markdownlint-cli/markdownlint.js ."
    end

    task :yamllint do
      sh "yamllint -c .yamllint.yml ."
    end

    task "aspell" do
      puts "Running aspell"
      files = []
      words = []
      Find.find("docs") do |path|
        next if File.directory?(path)

        files << path =~ /^[^.].*\md$/
      end
      files << "README.md" if File.exist?("README.md")
      files.each do |file|
        content = ""
        File.open(file) do |f|
          content = f.read
        end
        # XXX Ubuntu bionic version is lagged behind (0.60.7-20110707)
        # `--mode markdown` was implemented in 0.60.8. add that option when the
        # package is updated.
        o, e, status = Open3.capture3 "aspell " \
          "--lang en --personal ./.aspell.en.pws list",
                                      stdin_data: content
        raise "failed to run aspell: #{e}" unless status.success?

        next if o.empty?

        o.split("\n").each do |l|
          words << l
          puts "#{file}: #{l}"
        end
        puts "_____ candidates for .aspell.en.pws starts _____"
        puts words.uniq.join("\n").downcase
        puts "_____ candidates for .aspell.en.pws ends   _____"
        raise "aspell failed"
      end
    end

    task all: [:rubocop, :markdownlint, :yamllint, :aspell]
  end
  desc "Run tests performed in CI"
  task ci: ["ci:all"]
end
# rubocop:enable Metrics/BlockLength:
