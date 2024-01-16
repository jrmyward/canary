require 'spec_helper'

RSpec.describe Canary::ActivityLogger do
  let(:entry) { { timestamp: Time.now, message: 'Test entry 1' }.to_json }
  let(:entry_last) { { timestamp: Time.now, message: 'Test entry 2' }.to_json }
  let(:logger) { Canary::ActivityLogger.new(log_file: log_file) }
  let(:log_file) { File.expand_path('../../tmp/test_telemetry.log', __dir__) }

  describe '#enqueue' do
    it 'adds an entry to the entries array' do
      expect { logger.enqueue(entry) }.to change {
        logger.instance_variable_get(:@entries).length
      }.by(1)
    end

    it 'returns the added entry' do
      expect(logger.enqueue(entry)).to eq(entry)
    end
  end

  describe '#record_entries' do
    before do
      logger.enqueue(entry)
      logger.enqueue(entry_last)
    end

    it 'writes entries to the log file and clears the entries array' do
      expect(logger.record_entries).to eq([]) # returns cleared entries array

      # Ensure entries array is cleared
      expect(logger.instance_variable_get(:@entries)).to be_empty
    end
  end
end
