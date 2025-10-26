require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Configurações gerais
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  # Cache e logs
  config.action_controller.perform_caching = true
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }
  config.log_tags = [ :request_id ]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.silence_healthcheck_path = "/up"
  config.active_support.report_deprecations = false

  # Cache e filas
  config.cache_store = :solid_cache_store
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # Armazenamento de arquivos
  config.active_storage.service = :local # ActiveStorage salva arquivos localmente

  # Gera URLs corretas para imagens (ex: /rails/active_storage/blobs/...)
  config.active_storage.resolve_model_to_route = :rails_storage_proxy # URLs proxy para arquivos

  # Define o host para assets e URLs de imagens
  config.asset_host = "https://desafio-maino-filmes.onrender.com" # Host dos assets para Render

  # Configuração do Action Mailer para links corretos em emails
  config.action_mailer.default_url_options = { host: "desafio-maino-filmes.onrender.com", protocol: "https" }
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
