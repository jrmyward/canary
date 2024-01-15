require 'spec_helper'

RSpec.describe Canary::Simulator do
  let(:command) { 'ls -l' }

  subject { described_class.new(command: command) }

  # describe '#simulate_all' do

  # end
end
