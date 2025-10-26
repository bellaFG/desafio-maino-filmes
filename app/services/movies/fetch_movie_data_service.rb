# Service para buscar dados do filme via IA (OpenAI)
module Movies
  class FetchMovieDataService
    def self.call(title)
      return { error: I18n.t("movies.errors.title_required"), status: :bad_request } if title.blank?

      client = OpenAI::Client.new(api_key: ENV["OPENAI_API_KEY"])
      available_categories = Category.all.map(&:name)

      prompt = <<~PROMPT
        Gere informações resumidas e objetivas sobre o filme "#{title}" no formato JSON.
        Escolha a categoria mais adequada para o filme, mesmo que não esteja na lista abaixo.
        Se a categoria não estiver na lista, retorne a categoria correta para o filme.
        Também gere uma lista de até 10 tags curtas iniciando cada uma com letra maiúscula relacionadas ao filme (temas, estilos, palavras-chave).

        Categorias disponíveis: #{available_categories.join(", ")}

        Retorne exatamente neste formato JSON:
        {
          "title": "",
          "synopsis": "",
          "year": number,
          "duration": number,
          "director": "",
          "category": "",
          "tags": ["", "", "", "", "", "", "", "", "", ""]
        }
      PROMPT

      response = client.chat.completions.create(
        model: "gpt-4o-mini",
        messages: [ { role: "user", content: prompt } ],
        temperature: 0.3
      )

      content = response.choices[0].message[:content]
      cleaned = content.gsub(/```json/i, "").gsub(/```/, "").strip
      data = JSON.parse(cleaned) rescue {}

      data["tags"] ||= []

      if data["category"].present?
        normalized = I18n.transliterate(data["category"].strip).downcase
        existing_category = Category.all.find { |c| I18n.transliterate(c.name).downcase == normalized }
        if existing_category
          data["category"] = existing_category.name
        else
          category = Category.create(name: data["category"].strip)
          data["category"] = category.name
        end
      end

      if data["title"].blank?
        { error: I18n.t("movies.form.ai.invalid_data"), status: :unprocessable_entity }
      else
        data
      end
    rescue => e
      { error: I18n.t("movies.form.ai.integration_error", message: e.message), status: :internal_server_error }
    end
  end
end
