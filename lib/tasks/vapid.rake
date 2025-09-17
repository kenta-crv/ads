namespace :vapid do
  desc "Generate VAPID keys for web push notifications"
  task :generate => :environment do
    require 'webpush'
    
    begin
      vapid_key = Webpush.generate_key
      
      puts "Generated VAPID keys:"
      puts "===================="
      puts "Public Key:  #{vapid_key.public_key}"
      puts "Private Key: #{vapid_key.private_key}"
      puts ""
      puts "Add these to your Rails credentials:"
      puts "rails credentials:edit"
      puts ""
      puts "vapid:"
      puts "  public_key: \"#{vapid_key.public_key}\""
      puts "  private_key: \"#{vapid_key.private_key}\""
      puts ""
      puts "Or set as environment variables:"
      puts "export VAPID_PUBLIC_KEY=\"#{vapid_key.public_key}\""
      puts "export VAPID_PRIVATE_KEY=\"#{vapid_key.private_key}\""
      
    rescue => e
      puts "Error generating VAPID keys: #{e.message}"
      puts "Make sure the webpush gem is installed"
    end
  end
end
