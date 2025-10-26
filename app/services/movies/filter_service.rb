# Service para filtrar filmes conforme parâmetros de busca/filtro
module Movies
  class FilterService
    def self.call(params)
      movies = Movie.all
      movies = movies.where(year: params[:year]) if params[:year].present?
      movies = movies.joins(:categories).where(categories: { name: params[:category] }) if params[:category].present?
      movies = movies.where("director ILIKE ?", "%#{params[:director]}%") if params[:director].present?
      movies = movies.search(params[:q]) if params[:q].present?
      movies.order(created_at: :desc).page(params[:page]).per(6)
    end
  end
end
