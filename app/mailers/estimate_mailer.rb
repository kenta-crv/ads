class EstimateMailer < ActionMailer::Base
  default from: "info@ri-plus.jp"
  def received_email(estimate)
    @estimate = estimate
    mail to: "info@ri-plus.jp"
    mail(subject: 'サービス賃貸') do |format|
      format.text
    end
  end

  def send_email(estimate)
    @estimate = estimate
    mail to: estimate.email
    mail(subject: '恵比寿マンスリーマンションへのお問い合わせありがとうございました。') do |format|
      format.text
    end
  end
end