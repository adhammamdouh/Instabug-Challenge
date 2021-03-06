require 'redis-namespace'

redis_config = {
  url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/1'),
  namespace: "Instabug-Challenge"
}

Sidekiq.configure_server{|config| config.redis = redis_config }
Sidekiq.configure_client{|config| config.redis = redis_config }