require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Configurações gerais
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  # Cache e logs
  config.action_controller.perform_caching = true
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.silence_healthcheck_path = "/up"
  config.active_support.report_deprecations = false

  # Cache e filas
  config.cache_store = :solid_cache_store
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  config.active_storage.service = :local

  # Segurança e cookies HTTPS
  config.assume_ssl = true
  config.force_ssl = true

  config.session_store :cookie_store,
                       key: '_maino_filmes_session',
                       secure: true,
                       same_site: :none

  config.action_controller.forgery_protection_origin_check = false

  config.action_mailer.default_url_options = { host: "desafio-maino-filmes.onrender.com", protocol: "https" }

  config.i18n.fallbacks = true

  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]

  config.hosts << "desafio-maino-filmes.onrender.com"
  config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
