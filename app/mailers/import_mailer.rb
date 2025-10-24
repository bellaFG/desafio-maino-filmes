class ImportMailer < ApplicationMailer
  def completed
    @import = params[:import]
    mail(to: @import.user.email, subject: "Importação concluída!")
  end

  def failed
    @import = params[:import]
    @error = params[:error]
    mail(to: @import.user.email, subject: "Importação falhou!")
  end
end
