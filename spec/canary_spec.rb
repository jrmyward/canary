# frozen_string_literal: true

RSpec.describe Canary do
  it "has a version number" do
    expect(Canary::VERSION).not_to be nil
  end
end
