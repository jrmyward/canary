require 'spec_helper'

RSpec.describe Canary::ProcessSimulator do
  let(:command) { 'ls -l' }

  subject { described_class.new(command: command) }

  describe '#call' do
    let(:log_entry) do
      {
        timestamp: be_a(String),
        username: "user",
        pid: be_an(Integer),
        process_name: be_a(String),
        process_cmd_line: be_a(String)
      }.to_json
    end

    it 'returns process metadata' do
      allow(Open3).to receive(:capture3).and_return(['output', '', double(success?: true)])
      allow(Etc).to receive(:getlogin).and_return('user')

      expect(JSON.parse(subject.call).keys.sort).to eq(JSON.parse(log_entry).keys.sort)
    end
  end
end
