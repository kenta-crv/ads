require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rent
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # app/services を自動読み込み
    config.autoload_paths += %W(#{config.root}/app/services)

    # タイムゾーンを東京に設定
    config.time_zone = 'Tokyo'

    # メール送信の設定
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: 'smtp.lolipop.jp',
      domain: 'ebisu-hotel.tokyo',
      port: 587,
      user_name: 'info@ebisu-hotel.tokyo',
      password: ENV['EMAIL_PASSWORD'],
      authentication: 'plain',
      enable_starttls_auto: true
    }
  end
end
