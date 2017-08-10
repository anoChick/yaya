# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: (ENV['REDIS_URL'] || 'redis://localhost:6379').to_s }
end

Sidekiq.configure_client do |config|
  config.redis = { url: (ENV['REDIS_URL'] || 'redis://localhost:6379').to_s }
end
