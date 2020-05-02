# frozen_string_literal: true

require "motbot/account"

describe Motbot::Account do
  describe ".new" do
    context "when valid args given" do
      let(:args) { { secret: "foo", token: "bar" } }
      let(:obj) { Motbot::Account.new(args) }

      it "does not throw error" do
        expect { obj }.not_to raise_error
      end

      it "has correct pair of credential" do
        expect(obj.secret).to eq "foo"
        expect(obj.token).to eq "bar"
      end

      it "has client" do
        expect(obj.client.is_a?(Twitter::REST::Client)).to be true
      end
    end
  end
end
