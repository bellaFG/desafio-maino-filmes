# app/helpers/movies_helper.rb
module MoviesHelper
  def poster_variant(poster, width: 300, height: 450)
    return unless poster.attached?

    begin
      # Força o uso de MiniMagick
      poster.variant(resize_to_limit: [width, height], processor: :mini_magick).processed
    rescue => e
      Rails.logger.error "Erro ao gerar variante: #{e.message}"
      poster
    end
  end
end

