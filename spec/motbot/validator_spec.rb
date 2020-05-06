# frozen_string_literal: true

require "motbot/validator"
require "motbot/tweet"

N_MAX_TWEET_CHARACTER = 280

describe Motbot::Validator do
  before(:each) do
  end
  let(:obj) { Motbot::Validator.new }
  let(:tweet) { double(Motbot::Tweet) }

  describe "#valid?" do
    context "when tweet is not longer than N_MAX_TWEET_CHARACTER" do
      it "returns true" do
        allow(tweet).to receive(:status_str).and_return("x" * N_MAX_TWEET_CHARACTER)

        expect(obj.valid?(tweet)).to be true
      end
    end

    context "when tweet is too long" do
      it "raises exception" do
        allow(tweet).to receive(:status_str).and_return(("x" * (N_MAX_TWEET_CHARACTER + 1)))

        expect { obj.valid?(tweet) }.to raise_error(Motbot::Error::TweetTooLong)
      end
    end
  end

  describe "#valid_media_files?" do
    context "when more than four files given" do
      it "raises exception" do
        allow(tweet).to receive(:media_files).and_return(%w[1 2 3 4 5])

        expect { obj.valid_media_files?(tweet) }.to raise_error(Motbot::Error::TooManyMediaFiles)
      end
    end

    context "when a file that exists is given" do
      it "returns true" do
        allow(tweet).to receive(:media_files).and_return(["foo"])
        allow(obj).to receive(:config).and_return({ "assets" => { "media" => { "path" => "foo" } } })
        allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
        allow_any_instance_of(Pathname).to receive(:file?).and_return(true)
        allow_any_instance_of(Pathname).to receive(:readable?).and_return(true)

        expect(obj.valid_media_files?(tweet)).to eq true
      end
    end

    context "when not file is given" do
      it "returns errr" do
        allow(tweet).to receive(:media_files).and_return(["foo"])
        allow(obj).to receive(:config).and_return({ "assets" => { "media" => { "path" => "foo" } } })
        allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
        allow_any_instance_of(Pathname).to receive(:file?).and_return(false)

        expect { obj.valid_media_files?(tweet) }.to raise_error(Motbot::Error::InvalidMediaFiles)
      end
    end

    context "when unreadable file is given" do
      it "returns errr" do
        allow(tweet).to receive(:media_files).and_return(["foo"])
        allow(obj).to receive(:config).and_return({ "assets" => { "media" => { "path" => "foo" } } })
        allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
        allow_any_instance_of(Pathname).to receive(:file?).and_return(true)
        allow_any_instance_of(Pathname).to receive(:readable?).and_return(false)

        expect { obj.valid_media_files?(tweet) }.to raise_error(Motbot::Error::InvalidMediaFiles)
      end
    end
  end

  describe "#status?" do
    context "when tweet does not have a status" do
      it "raises error" do
        allow(tweet).to receive(:status).and_return(false)

        expect { obj.status?(tweet) }.to raise_error(Motbot::Error::MissingStatus)
      end
    end

    context "when status is empty string" do
      it "raises error" do
        allow(tweet).to receive(:status).and_return("")

        expect { obj.status?(tweet) }.to raise_error(Motbot::Error::MissingStatus)
      end
    end
  end

  describe "#valid_sources?" do
    context "when sources is missing" do
      it "raises error" do
        allow(tweet).to receive(:meta).and_return({ "foo" => "foo" })

        expect { obj.valid_sources?(tweet) }.to raise_error(Motbot::Error::InvalidSources)
      end
    end

    context "when sources is not an array" do
      it "raises error" do
        allow(tweet).to receive(:meta).and_return({ "foo" => {} })

        expect { obj.valid_sources?(tweet) }.to raise_error(Motbot::Error::InvalidSources)
      end
    end

    context "when sources is a string" do
      it "raises error" do
        allow(tweet).to receive(:meta).and_return({ "sources" => "foo" })

        expect { obj.valid_sources?(tweet) }.to raise_error(Motbot::Error::InvalidSources)
      end
    end

    context "when a source is not a string" do
      it "raises error" do
        allow(tweet).to receive(:meta).and_return({ "sources" => [{}] })

        expect { obj.valid_sources?(tweet) }.to raise_error(Motbot::Error::InvalidSources)
      end
    end
  end

  describe "#authors?" do
    context "when authors is empty" do
      it "raises exception" do
        allow(tweet).to receive(:meta).and_return({ "authors" => [] })

        expect { obj.authors?(tweet) }.to raise_error(Motbot::Error::MissingAuthors)
      end
    end

    context "when authors is not an array" do
      it "raises exception" do
        allow(tweet).to receive(:meta).and_return({ "authors" => "foo" })

        expect { obj.authors?(tweet) }.to raise_error(Motbot::Error::MissingAuthors)
      end
    end

    context "when authors is missing" do
      it "raises exception" do
        allow(tweet).to receive(:meta).and_return({})

        expect { obj.authors?(tweet) }.to raise_error(Motbot::Error::MissingAuthors)
      end
    end

    context "when an author is not String" do
      it "raises exception" do
        allow(tweet).to receive(:meta).and_return({ "authors" => ["foo", 1] })

        expect { obj.authors?(tweet) }.to raise_error(Motbot::Error::InvalidAuthor)
      end
    end
    context "when authors has two authors" do
      it "raises exception" do
        allow(tweet).to receive(:meta).and_return({ "authors" => %w[foo bar] })

        expect { obj.authors?(tweet) }.not_to raise_error
      end
    end

    context "when status is not UTF-8" do
      it "raises exception" do
        allow(tweet).to receive(:status).and_return("日本語".encode("euc-jp"))

        expect { obj.utf8?(tweet) }.to raise_error(Motbot::Error::InvalidFileEncoding)
      end
    end
  end
end
