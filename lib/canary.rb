# frozen_string_literal: true

require_relative "canary/version"

module Canary
  class Error < StandardError; end
  # Your code goes here...
end

require 'canary/activity_initiator'
require 'canary/process_activity_initiator'
