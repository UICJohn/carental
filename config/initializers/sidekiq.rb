Sidekiq.configure_server do |config|
  config.redis = if Rails.env.development? || Rails.env.test?
                   { url: 'redis://192.168.31.24:6379/0' }
                 else
                   { url: 'redis://localhost:6379/0', password: ENV['REDIS_PASSWORD'] }
                 end
end

Sidekiq.configure_client do |config|
  config.redis = if Rails.env.development? || Rails.env.test?
                   { url: 'redis://192.168.31.24:6379/0' }
                 else
                   { url: 'redis://localhost:6379/0', password: ENV['REDIS_PASSWORD'] }
                 end
end
