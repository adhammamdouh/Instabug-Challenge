redis_url = ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/1')

$redis = Redis.new(url: redis_url)