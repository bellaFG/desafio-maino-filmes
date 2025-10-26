class RootController < ApplicationController
  def index
    locale = cookies[:locale]&.to_sym || I18n.default_locale
    redirect_to movies_path(locale: locale)
  end
end
