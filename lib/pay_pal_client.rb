require 'paypal-checkout-sdk'

class PayPalClient
  def self.client
    PayPal::PayPalHttpClient.new(environment)
  end

  def self.environment
    PayPal::SandboxEnvironment.new(ENV['PAYPAL_CLIENT_ID'], ENV['PAYPAL_CLIENT_SECRET'])
  end
end
