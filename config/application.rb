require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MainoFilmes
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # 🌐 I18n: internacionalização
    config.i18n.available_locales = [:pt, :en]
    config.i18n.default_locale = :pt

    # 📁 Ignorar subpastas de lib que não precisam de reload
    config.autoload_lib(ignore: %w[assets tasks])

    # 🧵 Active Job: Sidekiq como adaptador de filas
    config.active_job.queue_adapter = :sidekiq

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
