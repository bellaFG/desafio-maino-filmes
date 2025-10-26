require "active_support/core_ext/integer/time"

Rails.application.configure do
  # ==============================
  # Configurações básicas
  # ==============================
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  # ==============================
  # Cache, logs e performance
  # ==============================
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}"
  }
  config.assets.compile = true
  config.log_tags = [ :request_id ]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.silence_healthcheck_path = "/up"
  config.active_support.report_deprecations = false

  # ==============================
  # Cache, filas e background jobs
  # ==============================
  config.cache_store = :solid_cache_store
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # ==============================
  # Active Storage (upload de imagens)
  # ==============================
  config.active_storage.service = :local
  config.active_storage.resolve_model_to_route = :rails_storage_proxy
  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"

  # ==============================
  # URLs, assets e host
  # ==============================
  config.asset_host = "https://desafio-maino-filmes.onrender.com"
  config.action_mailer.default_url_options = {
    host: "desafio-maino-filmes.onrender.com",
    protocol: "https"
  }

  # ==============================
  # E-mail (Mailtrap)
  # ==============================
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "sandbox.smtp.mailtrap.io",
    port:                 2525,
    user_name:            ENV["SMTP_USERNAME"],
    password:             ENV["SMTP_PASSWORD"],
    authentication:       "plain",
    enable_starttls_auto: true
  }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
end
