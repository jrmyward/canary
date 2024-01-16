module Canary
  class ActivityInitiator
    attr_accessor :command, :file, :logger

    def initialize(command:, file:)
      @command = command
      @file = file
      @logger = Canary::ActivityLogger.new(
        log_file: File.expand_path('../../log/test_telemetry.log', __dir__)
      )
    end

    def initiate_all
      puts "1. Initiate: Starting Process"
      initiate_process
      puts "2. Initiate: Creating File"
      initiate_file_creation
      puts "3. Initiate: Modifying File"
      initiate_file_modification
      puts "4. Initiate: Deleting File"
      initiate_file_deletion
      puts "5. Initiate: Network Connection and Transmitting Data"
      initiate_data_transfer
      puts "6. Record telemetry"
      logger.record_entries
    end

    def initiate_data_transfer
      Canary::NetworkActivityInitiator.new(logger: logger).call
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
      Canary::ProcessActivityInitiator.new(command: command, logger: logger).call
    end

    private

    def file_activity_initiator
      file_activity_initiator ||= Canary::FileActivityInitiator.new(file: file, logger: logger)
    end
  end
end
