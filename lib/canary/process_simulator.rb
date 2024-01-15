require 'etc'
require 'json'
require 'open3'

module Canary
  class ProcessSimulator
    attr_accessor :command

    def initialize(command:)
      @command = command
    end

    def call
      timestamp = Time.now.utc
      stdout, stderr, status = Open3.capture3(command)

      log_entry = log_call(timestamp, stdout, stderr, status)

      puts log_entry

      log_entry
    end

    private

    def current_process_cmd_line
      "#{$PROGRAM_NAME} #{ARGV.join(' ')}"
    end

    def log_call(timestamp, stdout, stderr, status)
      log = {
        timestamp: timestamp,
        username: Etc.getlogin,
        pid: Process.pid,
        process_name: $PROGRAM_NAME,
        process_cmd_line: current_process_cmd_line
        # success: status.success?,
        # output: status.success? ? stdout : stderr,
      }.to_json
    end
  end
end
