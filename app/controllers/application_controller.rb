class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :redirect_to_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

  def default_url_options
    { locale: I18n.locale }
  end
  
  private

  def set_locale
    I18n.locale = extract_locale
    store_locale(I18n.locale)
  end

  def extract_locale
    locale_from_params || locale_from_storage || locale_from_browser || I18n.default_locale
  end

  def locale_from_params
    if params[:locale].present?
      locale = params[:locale].to_sym
      I18n.available_locales.include?(locale) ? locale : nil
    end
  end

  def locale_from_storage
    stored = cookies[:locale]&.to_sym
    I18n.available_locales.include?(stored) ? stored : nil
  end

  def locale_from_browser
    accept_lang = request.env['HTTP_ACCEPT_LANGUAGE']
    return nil unless accept_lang

    browser_locale = accept_lang.scan(/^[a-z]{2}/).first&.to_sym
    I18n.available_locales.include?(browser_locale) ? browser_locale : nil
  end

  def store_locale(locale)
    cookies[:locale] = {
      value: locale,
      expires: 1.year.from_now,
      path: '/'
    }
  end

  def redirect_to_locale
    if request.path == '/' || request.path == '/en' || request.path == '/pt'
      redirect_to movies_path(locale: extract_locale)
    elsif !params[:locale].present?
      redirect_to "/#{extract_locale}#{request.path}", allow_other_host: true
    end
  end
end
