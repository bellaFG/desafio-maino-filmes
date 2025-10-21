Rails.application.routes.draw do
  devise_for :users

  resources :movies do
    resources :comments, only: [ :create, :destroy ]
  end

  # Rotas do Active Storage já estão automáticas
  # Ex.: rails_blob_path, rails_blob_url, rails_direct_uploads_path

  root "movies#index"
end
