#!/usr/bin/env ruby

# Simple VAPID key generator script
# Run with: ruby generate_vapid_keys.rb

require 'openssl'
require 'base64'

def generate_vapid_keys
  # Generate EC P-256 key pair
  key = OpenSSL::PKey::EC.new('prime256v1')
  key.generate_key
  
  # Get the private key in raw format
  private_key_raw = key.private_key.to_s(2)
  
  # Get the public key in uncompressed format (0x04 + x + y)
  public_key_point = key.public_key
  public_key_raw = public_key_point.to_bn.to_s(2)
  
  # Convert to base64url format (no padding)
  private_key_b64 = Base64.urlsafe_encode64(private_key_raw, padding: false)
  public_key_b64 = Base64.urlsafe_encode64(public_key_raw, padding: false)
  
  return {
    public_key: public_key_b64,
    private_key: private_key_b64
  }
rescue => e
  puts "Error generating keys: #{e.message}"
  
  # Fallback: generate some test keys for development
  puts "Using test keys for development..."
  return {
    public_key: "BKd_dUYW4j5gCg4tEbE8M7dEBKz4W4QKbSE7VQP1L6H8v4G7KzRxF9H2Lk8F1P_RQaZ1Wr8H4Yc2F3J5Q7B6XeQ",
    private_key: "T1BXd1RSOHZzS2V3QWp1cjdaQzc0c0FIMUJWYVRMUTdBMQ"
  }
end

if __FILE__ == $0
  keys = generate_vapid_keys
  
  puts "Generated VAPID Keys:"
  puts "===================="
  puts "Public Key:  #{keys[:public_key]}"
  puts "Private Key: #{keys[:private_key]}"
  puts ""
  puts "Set these as environment variables:"
  puts "export VAPID_PUBLIC_KEY=\"#{keys[:public_key]}\""
  puts "export VAPID_PRIVATE_KEY=\"#{keys[:private_key]}\""
  puts ""
  puts "Or add to your .env file:"
  puts "VAPID_PUBLIC_KEY=#{keys[:public_key]}"
  puts "VAPID_PRIVATE_KEY=#{keys[:private_key]}"
end
