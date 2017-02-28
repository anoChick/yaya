require ::File.expand_path('../config/environment',  __FILE__)
require ::File.expand_path('../bot/yaya', __FILE__)
Thread.abort_on_exception = true

Thread.new do
  SlackRubyBot::App.instance.run
end

run Rails.application
