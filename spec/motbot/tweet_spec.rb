# frozen_string_literal: true

require "motbot/tweet"

describe Motbot::Tweet do
  let(:tweet) { Motbot::Tweet.new("foo/bar.yml") }
  describe "when the tweet data is valid" do
    let(:hashed_tweet) do
      {
        status: "Hello world",
        possibly_sensitive: false,
        lat: 13.3707869,
        long: 103.8512576,
        place_id: "Cambodia",
        display_coordinates: true,
        card_uri: nil,
        media_files: [],
        timestamp: "2020-04-26T07:27:55+07:00"
      }
    end

    describe ".new" do
      before(:each) { allow_any_instance_of(Motbot::Tweet).to receive(:load_yaml).and_return(hashed_tweet) }

      it "does not throw an error" do
        expect { tweet }.not_to raise_error
      end
    end
  end

  describe "when the tweet data is invalid" do
    let(:status_empty) do
      {
        status: nil,
        timestamp: "2020-04-26T07:27:55+07:00"
      }
    end
    let(:timestamp_empty) do
      {
        status: nil,
        timestamp: "2020-04-26T07:27:55+07:00"
      }
    end

    describe ".new" do
      it "raises error" do
        allow_any_instance_of(Motbot::Tweet).to receive(:load_yaml).and_return(status_empty)
        expect { tweet }.to raise_error(Motbot::Tweet::Error)
      end

      it "raises error" do
        allow_any_instance_of(Motbot::Tweet).to receive(:load_yaml).and_return(timestamp_empty)
        expect { tweet }.to raise_error(Motbot::Tweet::Error)
      end
    end
  end
end
