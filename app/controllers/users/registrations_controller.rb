# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  # POST /resource
  def create
    super
  end

  # PUT /resource
  def update
    # Remove avatar se o hidden field vier como "true"
    if params[:user][:remove_avatar] == "true"
      resource.avatar.purge if resource.avatar.attached?
    end

    # Chama o Devise padrão para atualizar os outros campos
    super
  end

  protected

  # Permite nome e avatar no cadastro
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :avatar ])
  end

  # Permite nome e avatar no update (Devise precisa disso)
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :avatar ])
  end
end
