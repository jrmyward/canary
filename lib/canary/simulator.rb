module Canary
  class Simulator
    attr_accessor :command

    def initialize(command:)
      @command = command
    end

    def simulate_all
      puts "\nSimulate: Starting Process"
      simulate_process
      puts "\nSimulate: Creating File"
      puts "Simulate: Modifying File"
      puts "Simulate: Deleting File"
      puts "Simulate: Network Connection and Transmitting Data"
    end

    def simulate_process
      Canary::ProcessSimulator.new(command: command).call
    end
  end
end
