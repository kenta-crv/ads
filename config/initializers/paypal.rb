require 'paypal-checkout-sdk'

module PayPalClient
  class << self
    def environment
      PayPal::SandboxEnvironment.new(
        ENV['PAYPAL_CLIENT_ID'],
        ENV['PAYPAL_CLIENT_SECRET']
      )
    end

    def client
      PayPal::PayPalHttpClient.new(environment)
    end
  end
end
