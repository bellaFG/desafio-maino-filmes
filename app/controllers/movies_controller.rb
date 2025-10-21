class MoviesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_movie, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  # GET /movies
  def index
    @movies = Movie.order(created_at: :desc)
                   .by_title(params[:title])
                   .by_year(params[:year])
                   .by_director(params[:director])
                   .page(params[:page]).per(6)
  end

  # GET /movies/1
  def show; end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit; end

  # POST /movies
  def create
    @movie = current_user.movies.build(movie_params)
    assign_tags

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Filme criado com sucesso!" }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  def update
    assign_tags

    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Filme atualizado com sucesso!", status: :see_other }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  def destroy
    @movie.destroy!
    respond_to do |format|
      format.html { redirect_to movies_path, notice: "Filme excluído com sucesso!", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def authorize_user!
    redirect_to movies_path, alert: "Não autorizado" unless @movie.user == current_user
  end

  # 🎯 Permite campos de categorias, poster e tags
  def movie_params
    params.require(:movie).permit(
      :title, :synopsis, :year, :duration, :director, :poster, category_ids: []
    )
  end

  # 💡 Converte o campo de texto em tags reais (salva/cria)
  def assign_tags
    if params[:movie][:tag_list].present?
      tag_names = params[:movie][:tag_list].split(',').map(&:strip).uniq
      @movie.tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
    else
      @movie.tags.clear
    end
  end
end
