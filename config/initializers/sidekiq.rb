Sidekiq.configure_server do |config|
  config.redis = { url: (ENV['REDIS_URL']).to_s }
end

Sidekiq.configure_client do |config|
  config.redis = { url: (ENV['REDIS_URL']).to_s }
end
