require 'spec_helper'

RSpec.describe Canary::ProcessActivityInitiator do
  let(:command) { 'ls -l' }
  let(:expected_log_keys) do
    %w[timestamp username pid process_name process_cmd_line]
  end
  let(:logger) { Canary::ActivityLogger.new(log_file: log_file) }
  let(:log_file) { File.expand_path('../../tmp/test_telemetry.log', __dir__) }

  subject { described_class.new(command: command, logger: logger) }

  describe '#call' do
    it 'returns process metadata' do
      allow(Open3).to receive(:capture3).and_return(['output', '', double(success?: true)])
      allow(Etc).to receive(:getlogin).and_return('user')

      expect(JSON.parse(subject.call).keys.sort).to eq(expected_log_keys.sort)
    end
  end
end
