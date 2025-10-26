class MoviesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show fetch_movie_data]
  before_action :set_movie, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  # Listagem e filtros
  def index
    @movies = Movies::FilterService.call(params)
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
    Movies::AssignTagsService.call(@movie, params[:movie][:tag_list])

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
    Movies::AssignTagsService.call(@movie, params[:movie][:tag_list])

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

  # Integração com IA para preenchimento automático
  def fetch_movie_data
    result = Movies::FetchMovieDataService.call(params[:title])
    if result[:error]
      render json: { error: result[:error] }, status: result[:status] || :unprocessable_entity
    else
      render json: result
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def authorize_user!
    Movies::AuthorizeUserService.call(@movie, current_user) ||
      redirect_to(movies_path, alert: t("flash.unauthorized"))
  end

  def movie_params
    params.require(:movie).permit(:title, :synopsis, :year, :duration, :director, :poster, :remove_poster, category_ids: [])
  end
end
