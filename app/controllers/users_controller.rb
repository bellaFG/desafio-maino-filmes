class UsersController < ApplicationController
  before_action :authenticate_user!

  def remove_avatar
    if current_user.avatar.attached?
      current_user.avatar.purge
      flash[:notice] = "Avatar removido com sucesso."
    else
      flash[:alert] = "Você não tem avatar para remover."
    end
    redirect_back(fallback_location: root_path)
  end
end
