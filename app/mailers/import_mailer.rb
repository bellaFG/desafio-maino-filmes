class ImportMailer < ApplicationMailer
  def completed
    @import = params[:import]
    puts "📨 [MAILER] Enviando e-mail de sucesso para #{@import.user.email}"
    mail(to: @import.user.email, subject: "Importação concluída!")
  end

  def failed
    @import = params[:import]
    @error = params[:error]
    puts "📨 [MAILER] Enviando e-mail de erro para #{@import.user.email} — Motivo: #{@error}"
    mail(to: @import.user.email, subject: "Importação falhou!")
  end
end
