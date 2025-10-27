require "sendgrid-ruby"
include SendGrid

class SendGridMailer
  def initialize(values = {})
  end

  def deliver!(mail)
    from = Email.new(email: mail.from.first)
    to = Email.new(email: mail.to.first)
    content = Content.new(type: "text/html", value: mail.body.raw_source)

    mail_data = ::SendGrid::Mail.new(from, mail.subject, to, content)
    sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])

    begin
      response = sg.client.mail._("send").post(request_body: mail_data.to_json)
      Rails.logger.info("✅ SendGrid: Email sent with status #{response.status_code}")
    rescue => e
      Rails.logger.error("❌ SendGrid error: #{e.message}")
      raise e
    end
  end
end

# Registra o método customizado
ActionMailer::Base.add_delivery_method :sendgrid_api, SendGridMailer

# Define o método de entrega padrão
ActionMailer::Base.delivery_method = :sendgrid_api

# Define remetente padrão global
ActionMailer::Base.default_options = {
  from: ENV["MAIL_SENDER"] || "no-reply@desafio-maino-filmes.onrender.com"
}
