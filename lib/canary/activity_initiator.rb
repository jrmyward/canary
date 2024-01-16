module Canary
  class ActivityInitiator
    attr_accessor :command, :file

    def initialize(command:, file:)
      @command = command
      @file = file
    end

    def initiate_all
      puts "\nInitiate: Starting Process"
      initiate_process
      puts "\nInitiate: Creating File"
      initiate_file_creation
      puts "\nInitiate: Modifying File"
      initiate_file_modification
      puts "\nInitiate: Deleting File"
      initiate_file_deletion
      puts "\nInitiate: Network Connection and Transmitting Data"
    end

    def initiate_file_creation
      file_activity_initiator.create_file
    end

    def initiate_file_deletion
      file_activity_initiator.delete_file
    end

    def initiate_file_modification
      file_activity_initiator.modify_file
    end

    def initiate_process
      Canary::ProcessActivityInitiator.new(command: command).call
    end

    private

    def file_activity_initiator
      file_activity_initiator ||= Canary::FileActivityInitiator.new(file: file)
    end
  end
end
