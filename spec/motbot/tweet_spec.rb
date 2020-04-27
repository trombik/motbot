# frozen_string_literal: true

require "motbot/tweet"

describe Motbot::Tweet do
  context "when the tweet data is valid" do
    let(:tweet) { Motbot::Tweet.new("foo/bar.yml") }
    let(:hashed_tweet) do
      {
        "tweet" => {
          "status" => "Hello world,\nfoo",
          "possibly_sensitive" => false,
          "media_files" => []
        },
        "meta" => {
          "authors" => ["@ytrombik"],
          "reporters" => ["@ytrombik"],
          "tags" => ["test"],
          "timestamp" => "2020-04-26T07:27:55+07:00"
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

  context "when the tweet data is invalid" do
    let(:tweet) { Motbot::Tweet.new("foo/bar.yml") }
    let(:status_empty) do
      {
        "tweet" => {
          "possibly_sensitive" => false,
          "media_files" => []
        },
        "meta" => {
          "authors" => ["@ytrombik"],
          "reporters" => ["@ytrombik"],
          "tags" => ["test"],
          "timestamp" => "2020-04-26T07:27:55+07:00"
        }
      }
    end
    let(:timestamp_empty) do
      {
        "tweet" => {
          "status" => "Hello world",
          "possibly_sensitive" => false,
          "media_files" => []
        },
        "meta" => {
          "authors" => ["@ytrombik"],
          "reporters" => ["@ytrombik"],
          "tags" => ["test"],
          "timestamp" => nil
        }
      }
    end

    describe ".new" do
      it "raises error" do
        allow_any_instance_of(Motbot::Tweet).to receive(:load_yaml).and_return(status_empty)
        expect { tweet }.to raise_error(Motbot::Tweet::Error::InvalidTweet)
      end

      it "raises error" do
        allow_any_instance_of(Motbot::Tweet).to receive(:load_yaml).and_return(timestamp_empty)
        expect { tweet }.to raise_error(Motbot::Tweet::Error::InvalidTweet)
      end
    end
  end
end
