# frozen_string_literal: true

require "motbot/tweet"

describe Motbot::Tweet do
  before(:each) do
    allow_any_instance_of(Motbot::Tweet).to receive(:load_config).and_return(
      {
        "lang" => "en",
        "assets" => {
          "tweet" => {
            "path" => Pathname.pwd + "spec" + "fixtures" + "valid_assets" + "tweets"
          },
          "media" => {
            "path" => Pathname.pwd + "spec" + "fixtures" + "valid_assets" + "media"
          }
        }
      }
    )
  end
  context "when the tweet data is valid" do
    let(:tweet) { Motbot::Tweet.new("foo/bar.yml") }
    let(:hashed_tweet) do
      {
        "tweet" => {
          "status" => "Hello world,\nfoo  ",
          "possibly_sensitive" => false,
          "media_files" => []
        },
        "meta" => {
          "authors" => ["@ytrombik"],
          "reporters" => ["@ytrombik"],
          "tags" => ["test"],
          "timestamp" => "2020-04-26T07:27:55+07:00",
          "lang" => "en"
        }
      }
    end
    before(:each) { allow_any_instance_of(Motbot::Tweet).to receive(:load_yaml).and_return(hashed_tweet) }

    describe ".new" do
      it "does not throw an error" do
        expect { tweet }.not_to raise_error
      end

      it "replaces new line in status" do
        expect(tweet.status).not_to match(/\n/)
      end
    end
  end
end
