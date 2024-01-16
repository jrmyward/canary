require 'etc'
require 'json'
require 'open3'

module Canary
  class ProcessActivityInitiator
    attr_accessor :command, :logger

    def initialize(command:, logger:)
      @command = command
      @logger = logger
    end

    def call
      timestamp = Time.now.utc
      stdout, stderr, status = Open3.capture3(command)
      logger.enqueue(log_activity(timestamp, stdout, stderr, status))
    end

    private

    def current_process_cmd_line
      "#{$PROGRAM_NAME} #{ARGV.join(' ')}"
    end

    def log_activity(timestamp, stdout, stderr, status)
      {
        timestamp: timestamp,
        username: Etc.getlogin,
        pid: Process.pid,
        process_name: $PROGRAM_NAME,
        process_cmd_line: current_process_cmd_line
      }.to_json
    end
  end
end
