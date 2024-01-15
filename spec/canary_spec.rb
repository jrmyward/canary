# frozen_string_literal: true

RSpec.describe Canary do
  it "has a version number" do
    expect(Canary::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
