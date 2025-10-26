class ImportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @import = Import.new
  end

  def create
    puts "🚀 [IMPORTS_CONTROLLER] Iniciando importação..."

    @import = current_user.imports.build(import_params)
    @import.status = :pending  # garante o status inicial
    puts "📦 [IMPORTS_CONTROLLER] Arquivo recebido: #{import_params[:file]&.original_filename}"

    if @import.save
      puts "✅ [IMPORTS_CONTROLLER] Import salvo no banco com ID: #{@import.id}"
      puts "🧵 [IMPORTS_CONTROLLER] Enfileirando job Sidekiq..."
      MovieImportWorker.perform_async(@import.id)

      redirect_to imports_path,
                  notice: "📦 Importação iniciada! Você será notificada quando o processo for concluída."
    else
      puts "❌ [IMPORTS_CONTROLLER] Falha ao salvar import: #{@import.errors.full_messages.join(', ')}"
      flash[:alert] = "❌ Erro ao enviar o arquivo CSV. Verifique e tente novamente."
      render :new, status: :unprocessable_entity
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
