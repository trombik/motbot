# frozen_string_literal: true

require "motbot/app"
require "time"
require "pathname"

describe "Motbot::App" do
  config = {
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
  before(:each) do
    allow_any_instance_of(Motbot::App).to receive(:load_config).and_return(config)
    allow_any_instance_of(Motbot::Tweet).to receive(:load_config).and_return(config)
    allow_any_instance_of(Motbot::Validator).to receive(:load_config).and_return(config)
  end

  describe ".new" do
    it "does not throw error" do
      expect { Motbot::App.new }.not_to raise_error
    end
  end

  describe "#load_tweets" do
    let(:app) { Motbot::App.new }
    context "when the directory contains valid assets" do
      let(:path) { Pathname.new(__FILE__).dirname.parent + "fixtures" + "valid_assets" }

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

  describe "#disabled?" do
    let(:app) { Motbot::App.new }
    let(:tweet) { double(Motbot::Tweet) }

    context "when state is disabled" do
      it "returns true" do
        allow(tweet).to receive(:meta).and_return({ "state" => "disabled" })

        expect(app.disabled?(tweet)).to be true
      end
    end

    context "when state is not disabled" do
      it "returns false" do
        allow(tweet).to receive(:meta).and_return({ "state" => "enabled" })

        expect(app.disabled?(tweet)).to be false
      end
    end

    context "when state does not exist" do
      it "returns false" do
        allow(tweet).to receive(:meta).and_return({})

        expect(app.disabled?(tweet)).to be false
      end
    end
  end
  describe "#today?" do
    let(:app) { Motbot::App.new }
    let(:tweet) { double(Motbot::Tweet) }
    let(:timestamp) { double(Time) }
    let(:now) { Time.now }

    before(:each) do
      allow_any_instance_of(Motbot::App).to receive(:time_now).and_return(now)
    end
    context "when the event date is yesterday" do
      it "returns false" do
        allow(tweet).to receive(:meta).and_return({ "timestamp" => now - 86_400 })

        expect(app.today?(tweet)).to be false
      end
    end

    context "when the event date is today" do
      it "returns true" do
        allow(tweet).to receive(:meta).and_return({ "timestamp" => now })

        expect(app.today?(tweet)).to be true
      end
    end

    context "when the event date is one year ago today"
    let(:d) { Date.today }
    let(:last_year) { Date.civil(d.year - 1, d.month, d.day) }

    it "returns true" do
      allow(tweet).to receive(:meta).and_return({ "timestamp" => last_year })

      expect(app.today?(tweet)).to be true
    end
  end
end
