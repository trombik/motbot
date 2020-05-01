# frozen_string_literal: true

require "motbot/config"

describe "Motbot::Config" do
  let(:obj) { Motbot::Config }
  describe ".new" do
    let(:config) do
      {
        "lang" => "en",
        "assets" => {
          "tweet" => {
            "path" => "assets/tweets"
          }
        },
        "media" => {
          "path" => "assets/media"
        }
      }
    end

    it "does not raise error" do
      allow_any_instance_of(Motbot::Config).to receive(:load_config).and_return(config)

      expect { obj.new("foo.yml") }.not_to raise_error
    end

    it "returns Hash" do
      allow_any_instance_of(Motbot::Config).to receive(:load_config).and_return(config)

      expect(obj.new("foo.yml").config.kind_of?(Hash)).to be true
      expect(obj.new("foo.yml").config.keys.length).to eq 3
    end
  end
end
