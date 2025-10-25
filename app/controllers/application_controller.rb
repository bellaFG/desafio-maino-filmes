class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

  private

  def set_locale
    locale = params[:locale]&.to_sym
    I18n.locale = I18n.available_locales.include?(locale) ? locale : I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
