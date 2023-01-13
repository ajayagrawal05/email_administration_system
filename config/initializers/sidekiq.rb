# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq_unique_jobs/web' if defined?(SidekiqUniqueJobs)
require 'sidekiq/cron/web' if defined?(Sidekiq::Cron)

# sidekiq unique jobs default config
SidekiqUniqueJobs.configure do |config|
  config.enabled         = !Rails.env.test?
  config.logger          = Sidekiq.logger # default, change at your own discretion
  config.debug_lua       = false # Turn on when debugging
  config.lock_info       = false # Turn on when debugging
  config.lock_ttl        = 3600   # Expire locks after 10 minutes
  config.lock_timeout    = 0   # turn off lock timeout
  config.max_history     = 0     # Turn on when debugging
  config.reaper          = :ruby # :ruby, :lua or :none/nil
  config.reaper_count    = 1000  # Stop reaping after this many keys
  config.reaper_interval = 600   # Reap orphans every 10 minutes
  config.reaper_timeout  = 150   # Timeout reaper after 2.5 minutes
end

# REDIS_POOL = ConnectionPool.new(size: 10, timeout: 60) { Redis.new(url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" }) }
REDIS_POOL = ConnectionPool.new(size: 10, timeout: 60) { Redis.new(host: ENV["REDISHOST"], port: ENV["REDISPORT"], db: 0) }

Sidekiq.configure_server do |config|
  config.redis = REDIS_POOL

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_POOL

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV["SIDEKIQ_USERNAME"] || "admin", ENV["SIDEKIQ_PASSWORD"] || "legitimate"]
end

schedule_file = "config/schedule.yml"

if File.exist?(schedule_file) #&& Sidekiq.server?
  # Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

Sidekiq::Web.set :sessions, false
Sidekiq.default_worker_options = { retry: 0 }
