# frozen_string_literal: true

require "motbot/pretext"

describe Motbot::PreText do
  describe ".new" do
    context "when the language is supported" do
      let(:supported) { %w[en ja] }

      it "does not throw err" do
        supported.each do |lang|
          expect { Motbot::PreText.new(lang: lang, timestamp: Time.now) }.not_to raise_error
        end
      end
    end
  end

  describe "#to_s" do
    let(:now) { Time.now }
    let(:timestamps) do
      [now, now - 86_400, now - 86_400 * 10]
    end

    context "when the language is supported" do
      let(:supported) { %w[en ja] }
      it "returns string" do
        timestamps.each do |timestamp|
          supported.each do |lang|
            obj = Motbot::PreText.new(lang: lang, timestamp: timestamp)
            expect(obj.to_s.is_a?(String)).to be true
            expect(obj.to_s.length).to be > 0
          end
        end
      end
    end

    context "when the language is not supported" do
      it "raises error" do
        timestamps.each do |timestamp|
          obj = Motbot::PreText.new(lang: "foo", timestamp: timestamp)
          expect { obj.to_s }.to raise_error(Motbot::PreText::Error::UnsupportedLanguage)
        end
      end
    end

    context "when the language is nil" do
      it "raises error" do
        timestamps.each do |timestamp|
          obj = Motbot::PreText.new(lang: nil, timestamp: timestamp)
          expect { obj.to_s }.to raise_error(ArgumentError)
        end
      end
    end
    context "when the timestamp is nil" do
      it "raises error" do
        expect { Motbot::PreText.new(lang: "en", timestamp: nil) }.to raise_error(ArgumentError)
      end
    end

    context "when the event took place today" do
      it "begins with Today" do
        obj = Motbot::PreText.new(lang: "en", timestamp: now)
        allow(obj).to receive(:time_now).and_return(now)
        expect(obj.to_s).to match(/^Today: /)
      end
    end

    context "when the event took place last year" do
      it "begins with Last year" do
        obj = Motbot::PreText.new(lang: "en", timestamp: now - 86_400 * 365)
        allow(obj).to receive(:time_now).and_return(now)
        expect(obj.to_s).to match(/^Last year today: /)
      end
    end

    context "when the event took place 10 years ago" do
      it "begins with Last year" do
        obj = Motbot::PreText.new(lang: "en", timestamp: now - 86_400 * 365 * 10)
        allow(obj).to receive(:time_now).and_return(now)
        expect(obj.to_s).to match(/^10 years ago today: /)
      end
    end

    context "when the event took place 10 years ago, and the lang is ja" do
      it "begins with 10年前の今日" do
        obj = Motbot::PreText.new(lang: "ja", timestamp: now - 86_400 * 365 * 10)
        allow(obj).to receive(:time_now).and_return(now)
        expect(obj.to_s).to match(/^10年前の今日: /)
      end
    end
  end
end
