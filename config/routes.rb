Rails.application.routes.draw do
  # Root route using controller
  root to: 'root#index'

  # Route to capture only locale
  get '/:locale', to: redirect('/%{locale}/movies'), constraints: { locale: /#{I18n.available_locales.join('|')}/ }

  # Locale scope
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, controllers: { registrations: "users/registrations" }

    resources :movies do
      resources :comments, only: [ :create, :destroy, :edit, :update ]

      collection do
        get :fetch_movie_data
      end
    end

    resources :imports, only: [ :new, :create, :index ]
  end
end
