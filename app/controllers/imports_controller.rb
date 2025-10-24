class ImportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @import = Import.new
  end

  def create
    @import = current_user.imports.build(import_params)
    if @import.save
      MovieImportWorker.perform_async(@import.id)
      redirect_to imports_path, notice: "Importação iniciada! Você será notificado por e-mail ao concluir."
    else
      render :new
    end
  end

  def index
    @imports = current_user.imports.order(created_at: :desc)
  end

  private

  def import_params
    params.require(:import).permit(:file)
  end
end
