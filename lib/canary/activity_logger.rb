module Canary
  class ActivityLogger
    attr_accessor :log_file
    def initialize(log_file:)
      @entries = []
      @log_file = log_file
    end

    def enqueue(entry)
      @entries.push(entry)
      entry
    end

    def record_entries
      return if @entries.empty?

      File.open(log_file, 'a') do |file|
        @entries.each do |entry|
          file.puts(entry)
        end
      end

      @entries.clear
    end
  end
end
