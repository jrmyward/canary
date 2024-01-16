require 'spec_helper'

RSpec.describe Canary::ActivityInitiator do
  let(:command) { 'ls -l' }

  subject { described_class.new(command: command) }

  # describe '#initiate_all' do

  # end
end
