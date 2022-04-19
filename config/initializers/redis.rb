redis_host = 'localhost'
redis_port = 6379

# The constant below will represent ONE connection, present globally in models, controllers, views etc for the instance. No need to do Redis.new everytime
$redis = Redis.new(host: redis_host, port: redis_port)