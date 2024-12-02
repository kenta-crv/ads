class ContactMailer < ActionMailer::Base
  default from: "info@ebisu-hotel.tokyo"
  def received_email(contact)
    @contact = contact
    mail to: "info@ebisu-hotel.tokyo"
    mail(subject: '恵比寿レントサービスにお問い合わせがありました') do |format|
      format.text
    end
  end

  def send_email(contact)
    @contact = contact
    mail to: contact.email
    mail(subject: '恵比寿レントサービスにお問い合わせ頂きありがとうございます。') do |format|
      format.text
    end
  end
end
