require "sendgrid-ruby"
include SendGrid

class SendGridMailer
  def self.deliver!(mail)
    from = Email.new(email: mail.from.first)
    to = Email.new(email: mail.to.first)
    content = Content.new(type: "text/html", value: mail.body.raw_source)

    mail_data = Mail.new(from, mail.subject, to, content)
    sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])
    sg.client.mail._("send").post(request_body: mail_data.to_json)
  end
end

ActionMailer::Base.add_delivery_method :sendgrid_api, SendGridMailer
ActionMailer::Base.delivery_method = :sendgrid_api

ActionMailer::Base.default_options = {
  from: ENV["MAIL_SENDER"] || "no-reply@desafio-maino-filmes.onrender.com"
}
