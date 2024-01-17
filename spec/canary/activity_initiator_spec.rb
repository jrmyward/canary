require "spec_helper"

RSpec.describe Canary::ActivityInitiator do
  let(:command) { "ls -l" }
  let(:file) { "test_file.txt" }

  subject do
    described_class.new(
      command: command,
      file: file
    )
  end

  describe "#initiate_all" do
    it "initiates all activities and records telemetry" do
      expect(subject).to receive(:initiate_process).ordered
      expect(subject).to receive(:initiate_file_creation).ordered
      expect(subject).to receive(:initiate_file_modification).ordered
      expect(subject).to receive(:initiate_file_deletion).ordered
      expect(subject).to receive(:initiate_data_transfer).ordered
      expect(subject.logger).to receive(:record_entries).ordered

      subject.initiate_all
    end
  end

  describe "#initiate_data_transfer" do
    it "calls NetworkActivityInitiator with the logger" do
      network_initiator = instance_double("Canary::NetworkActivityInitiator")
      allow(Canary::NetworkActivityInitiator).to receive(:new).with(logger: subject.logger)
                                                              .and_return(network_initiator)
      expect(network_initiator).to receive(:call)

      subject.initiate_data_transfer
    end
  end

  describe "#initiate_file_creation" do
    it "calls create_file on FileActivityInitiator" do
      file_initiator = instance_double("Canary::FileActivityInitiator")
      allow(Canary::FileActivityInitiator).to receive(:new).with(file: file, logger: subject.logger)
                                                           .and_return(file_initiator)
      expect(file_initiator).to receive(:create_file)

      subject.initiate_file_creation
    end
  end

  describe "#initiate_file_deletion" do
    it "calls delete_file on FileActivityInitiator" do
      file_initiator = instance_double("Canary::FileActivityInitiator")
      allow(Canary::FileActivityInitiator).to receive(:new).with(file: file, logger: subject.logger)
                                                           .and_return(file_initiator)
      expect(file_initiator).to receive(:delete_file)

      subject.initiate_file_deletion
    end
  end

  describe "#initiate_file_modification" do
    it "calls modify_file on FileActivityInitiator" do
      file_initiator = instance_double("Canary::FileActivityInitiator")
      allow(Canary::FileActivityInitiator).to receive(:new).with(file: file, logger: subject.logger)
                                                           .and_return(file_initiator)
      expect(file_initiator).to receive(:modify_file)

      subject.initiate_file_modification
    end
  end

  describe "#initiate_process" do
    it "calls call on ProcessActivityInitiator" do
      process_initiator = instance_double("Canary::ProcessActivityInitiator")
      allow(Canary::ProcessActivityInitiator).to receive(:new).with(command: command, logger: subject.logger)
                                                              .and_return(process_initiator)
      expect(process_initiator).to receive(:call)

      subject.initiate_process
    end
  end
end
