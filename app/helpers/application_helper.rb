module ApplicationHelper
  def locale_name(locale)
    { pt: "PT", en: "EN" }[locale.to_sym] || locale.to_s.upcase
  end
end
