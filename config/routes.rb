Rails.application.routes.draw do
  # Autenticação Devise
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Filmes e comentários
  resources :movies do
    # Comentários aninhados
    resources :comments, only: [:create, :destroy, :edit, :update]

    # Busca de dados de filme via IA (AJAX)
    collection do
      get :fetch_movie_data
    end
  end

  # Importações de CSV
  resources :imports, only: [:new, :create, :index]

  # Rota padrão
  root "movies#index"
end
