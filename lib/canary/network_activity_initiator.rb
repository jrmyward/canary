require 'etc'
require 'json'
require 'socket'

module Canary
  class NetworkActivityInitiator
    PROTOCOL = 'tcp'

    attr_accessor :data, :hostname, :logger, :port

    def initialize(logger:)
      @hostname = "www.google.com"
      @logger = logger
      @port = 80
    end

    def call
      socket = TCPSocket.new(hostname, port)
      socket.send(data, 0)

      timestamp = Time.now.utc
      dest_ip, dest_port = socket.peeraddr[3], socket.peeraddr[1]
      src_ip, src_port = socket.addr[3], socket.addr[1]
      bytes_sent = data.bytesize

      socket.close
      logger.enqueue(log_activity(timestamp, dest_ip, dest_port, src_ip, src_port, bytes_sent))
    end

    private

    def current_process_cmd_line
      "#{$PROGRAM_NAME} #{ARGV.join(' ')}"
    end

    def data
      "GET / HTTP/1.1\r\nHost:#{hostname}\r\n\r\n".encode
    end

    def log_activity(timestamp, dest_ip, dest_port, src_ip, src_port, bytes_sent)
      {
        timestamp: timestamp,
        username: Etc.getlogin,
        pid: Process.pid,
        process_name: $PROGRAM_NAME,
        process_cmd_line: current_process_cmd_line,
        destination_ip: dest_ip,
        destination_port: dest_port,
        source_ip: src_ip,
        source_port: src_port,
        bytes_sent: bytes_sent,
        protocol: PROTOCOL
      }.to_json
    end
  end
end
