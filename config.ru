# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require_relative 'yaya_bot'

Thread.abort_on_exception = true

Thread.new do
  YayaBot::Bot.run
end
run Rails.application
