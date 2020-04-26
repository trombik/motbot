# frozen_string_literal: true

require "motbot/app"
require "time"
require "pathname"

describe "Motbot::App" do
  describe ".new" do
    it "does not throw error" do
      expect { Motbot::App.new }.not_to raise_error
    end
  end

  describe "#load_tweets" do
    let(:app) { Motbot::App.new }
    context "when the directory contains valid tweets" do
      let(:path) { Pathname.new(__FILE__).dirname.parent + "fixtures" + "valid_tweets" }

      it "raises no error" do
        expect { app.load_tweets(path.to_s) }.not_to raise_error
      end

      it "returns two tweets" do
        expect(app.load_tweets(path.to_s).length).to eq 2
      end
    end
  end

  describe "#time_now" do
    let(:app) { Motbot::App.new }
    it "returns Time instance" do
      expect(app.time_now.class).to be Time
    end
  end

  describe "#today?" do
    let(:app) { Motbot::App.new }
    let(:tweet) { double(Motbot::Tweet) }
    let(:timestamp) { double(Time) }
    let(:now) { Time.now }

    before(:each) do
      allow_any_instance_of(Motbot::App).to receive(:time_now).and_return(now)
      allow(tweet).to receive(:timestamp).and_return(timestamp)
      allow(timestamp).to receive(:month).and_return(now.month)
    end
    context "when the event date is yesterday" do
      it "returns false" do
        allow(timestamp).to receive(:day).and_return(now.day - 1)

        expect(app.today?(tweet)).to be false
      end
    end

    context "when the event date is today" do
      it "returns true" do
        allow(timestamp).to receive(:day).and_return(now.day)

        expect(app.today?(tweet)).to be true
      end
    end
  end
end
