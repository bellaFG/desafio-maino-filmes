class MoviesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show fetch_movie_data]
  before_action :set_movie, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @movies = Movie.all
    @movies = @movies.where(year: params[:year]) if params[:year].present?
    @movies = @movies.joins(:categories).where(categories: { name: params[:category] }) if params[:category].present?
    @movies = @movies.where("director ILIKE ?", "%#{params[:director]}%") if params[:director].present?
    @movies = @movies.search(params[:q]) if params[:q].present?
    @movies = @movies.order(created_at: :desc).page(params[:page]).per(6)
  end

  def show
    @comments = @movie.comments.order(created_at: :desc)
  end

  def new
    @movie = Movie.new
  end

  def edit; end

  def create
    @movie = current_user.movies.build(movie_params)
    assign_tags

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: t("flash.created") }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    assign_tags

    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: t("flash.updated"), status: :see_other }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, notice: t("flash.destroyed"), status: :see_other }
      format.json { head :no_content }
    end
  end

  def fetch_movie_data
    title = params[:title]
    return render json: { error: I18n.t("movies.errors.title_required") }, status: :bad_request if title.blank?

    begin
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
          available_categories << category.name
        end
      end

      if data["title"].blank?
        render json: { error: "IA não retornou dados válidos." }, status: :unprocessable_entity
      else
        render json: data
      end
    rescue => e
      render json: { error: "Erro na integração com a IA: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def authorize_user!
    redirect_to movies_path, alert: t("flash.unauthorized") unless @movie.user == current_user
  end

  def movie_params
    params.require(:movie).permit(:title, :synopsis, :year, :duration, :director, :poster, :remove_poster, category_ids: [])
  end

  def assign_tags
    if params[:movie][:tag_list].present?
      tag_names = params[:movie][:tag_list].split(",").map(&:strip).uniq
      @movie.tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
    else
      @movie.tags.clear
    end
  end
end
