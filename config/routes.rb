Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :movies do
    resources :comments, only: [:create, :destroy, :edit, :update]
  end

  root "movies#index"
end
