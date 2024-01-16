require 'etc'
require 'fileutils'
require 'json'

module Canary
  class FileActivityInitiator
    ACTIVITY_CREATE = "create"
    ACTIVITY_DELETE = "delete"
    ACTIVITY_UPDATE = "modified"

    attr_accessor :file_path

    def initialize(file:)
      @file_path = File.expand_path(file)
    end

    def create_file
      return if File.exists?(file_path)

      timestamp = Time.now.utc
      FileUtils.mkdir_p(File.dirname(file_path))
      File.open(file_path, "w")
      log_entry(ACTIVITY_CREATE, timestamp)
    end

    def delete_file
      return unless File.exists?(file_path)

      timestamp = Time.now.utc
      File.delete(file_path)
      log_entry(ACTIVITY_DELETE, timestamp)
    end

    def modify_file
      return unless File.exists?(file_path)

      timestamp = Time.now.utc
      File.write(file_path, "Modified content")
      log_entry(ACTIVITY_UPDATE, timestamp)
    end

    private

    def current_process_cmd_line
      "#{$PROGRAM_NAME} #{ARGV.join(' ')}"
    end

    def log_entry(activity, timestamp)
      entry = log_activity(activity, timestamp)
      puts entry
      entry
    end

    def log_activity(activity, timestamp)
      log = {
        timestamp: timestamp,
        username: Etc.getlogin,
        pid: Process.pid,
        process_name: $PROGRAM_NAME,
        process_cmd_line: current_process_cmd_line,
        file_path: file_path,
        activity: activity
      }.to_json
    end
  end
end
