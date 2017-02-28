Thread.abort_on_exception = true

Thread.new do
  SlackRubyBot::App.instance.run
end
