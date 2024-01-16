module Canary
  class ActivityInitiator
    attr_accessor :command

    def initialize(command:)
      @command = command
    end

    def initiate_all
      puts "\nInitiate: Starting Process"
      initiate_process
      puts "\nInitiate: Creating File"
      puts "Initiate: Modifying File"
      puts "Initiate: Deleting File"
      puts "Initiate: Network Connection and Transmitting Data"
    end

    def initiate_process
      Canary::ProcessActivityInitiator.new(command: command).call
    end
  end
end
