Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :movies do
    resources :comments, only: [ :create, :destroy, :edit, :update ]

    collection do
      get :fetch_movie_data
    end
  end

  resources :imports, only: [ :new, :create, :index ]

  root "movies#index"
end
