require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Enable Lograge for concise logging
  config.lograge.enabled = true

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot for better performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensure a master key is required for credentials.
  config.require_master_key = true

  # Disable serving static files by default (handled by Render or CDN).
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Enable compression for assets.
  config.assets.js_compressor = :uglifier
  config.assets.compile = false

  # Use a header suitable for NGINX for file sending.
  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"

  # Force all access to the app over SSL and use secure cookies.
  config.force_ssl = true

  # Set log level to info for better visibility.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use Redis as the cache store
  config.cache_store = :redis_cache_store, { url: ENV["REDIS_URL"] }

  # Active Job queue adapter (using Redis).
  config.active_job.queue_adapter = :sidekiq

  # Action Mailer configuration for email delivery.
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV.fetch("SMTP_ADDRESS", "smtp.sendgrid.net"),
    port: 587,
    domain: ENV.fetch("SMTP_DOMAIN", "example.com"),
    user_name: ENV["SMTP_USERNAME"],
    password: ENV["SMTP_PASSWORD"],
    authentication: :plain,
    enable_starttls_auto: true
  }
  config.action_mailer.default_url_options = {
    host: ENV["CANONICAL_HOST"],
    protocol: "https"
  }

  # Action Cable configuration (WebSockets for real-time updates).
  config.action_cable.url = "wss://#{ENV['CANONICAL_HOST']}/cable"
  config.action_cable.allowed_request_origins = [
    "https://#{ENV['CANONICAL_HOST']}",
    "http://#{ENV['CANONICAL_HOST']}"
  ]

  # I18n fallback for missing translations.
  config.i18n.fallbacks = true

  # Suppress deprecation warnings.
  config.active_support.report_deprecations = false

  # Default logging formatter.
  config.log_formatter = ::Logger::Formatter.new

  # Log to STDOUT if specified.
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
