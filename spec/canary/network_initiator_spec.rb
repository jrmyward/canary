require 'spec_helper'

RSpec.describe Canary::NetworkActivityInitiator do
  let(:expected_log_keys) do
    %w[
      timestamp username pid process_name process_cmd_line destination_ip destination_port
      source_ip source_port bytes_sent protocol
    ]
  end
  let(:logger) { Canary::ActivityLogger.new(log_file: log_file) }
  let(:log_file) { File.expand_path('../../tmp/test_telemetry.log', __dir__) }

  subject { described_class.new(logger: logger) }

  describe '#call' do
    it 'returns appropriate telemetry' do
      expect(JSON.parse(subject.call).keys.sort).to eq(expected_log_keys.sort)
    end
  end
end
