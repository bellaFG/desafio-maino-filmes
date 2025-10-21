class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Permite enviar o campo :name nos formulários do Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 🌐 Internacionalização: define o idioma com base no parâmetro de URL
  before_action :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Mantém o locale em todos os links do app
  def default_url_options
    { locale: I18n.locale }
  end
end

