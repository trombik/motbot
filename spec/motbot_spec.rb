# frozen_string_literal: true

require "motbot"

RSpec.describe Motbot do
  it "has a version number" do
    expect(Motbot::VERSION).not_to be nil
  end
end
