require "spec_helper"

RSpec.describe Canary::FileActivityInitiator do
  let(:expected_log_keys) do
    %w[timestamp username pid process_name process_cmd_line file_path activity]
  end
  let(:file) { "./tmp/test_file.txt" }
  let(:file_path) { File.expand_path(file) }

  subject { described_class.new(file: file) }

  after do
    File.delete(file_path) if File.exists?(file_path)
  end

  describe "#create_file" do
    context "when file exists" do
      it "does not create a file if it already exists" do
        File.open(file_path, "w")

        expect { subject.create_file }.not_to change { File.mtime(file_path) }
      end
    end

    it "creates a new file" do
      expect(subject.create_file).to include(Canary::FileActivityInitiator::ACTIVITY_CREATE)
      expect(File).to exist(file_path)
    end

    it "returns appropriate telemetry" do
      expect(JSON.parse(subject.create_file).keys.sort).to eq(expected_log_keys.sort)
    end
  end

  describe "#delete_file" do
    context "when file does not exist" do
      it "does nothing" do
        expect { subject.delete_file }.not_to change { File.exist?(file_path) }
      end
    end

    context "when file exists" do
      before do
        File.open(file_path, "w")
      end

      it "deletes an existing file" do
        expect(subject.delete_file).to include(Canary::FileActivityInitiator::ACTIVITY_DELETE)
        expect(File).not_to exist(file_path)
      end

      it "returns appropriate telemetry" do
        expect(JSON.parse(subject.delete_file).keys.sort).to eq(expected_log_keys.sort)
      end
    end
  end

  describe '#modify_file' do
    context "when file does not exist" do
      it 'does nothing' do
        expect { subject.modify_file }.not_to change { File.exist?(file_path) }
      end
    end

    context "when file exists" do
      before do
        File.open(file_path, "w")
      end

      it 'modifies an existing file' do
        expect(subject.modify_file).to include(Canary::FileActivityInitiator::ACTIVITY_UPDATE)
      end

      it "returns appropriate telemetry" do
        expect(JSON.parse(subject.modify_file).keys.sort).to eq(expected_log_keys.sort)
      end
    end
  end
end
