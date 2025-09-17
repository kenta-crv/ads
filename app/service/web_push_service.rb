require "webpush"

class WebPushService
  def self.send_notification(subscriber, payload)
    public_key = Rails.application.credentials.dig(:vapid, :public_key) || ENV['VAPID_PUBLIC_KEY'] || 'BKd_dUYW4j5gCg4tEbE8M7dEBKz4W4QKbSE7VQP1L6H8v4G7KzRxF9H2Lk8F1P_RQaZ1Wr8H4Yc2F3J5Q7B6XeQ'
    private_key = Rails.application.credentials.dig(:vapid, :private_key) || ENV['VAPID_PRIVATE_KEY'] || 'T1BXd1RSOHZzS2V3QWp1cjdaQzc0c0FIMUJWYVRMUTdBMQ'
    
    if !public_key || !private_key
      Rails.logger.error "VAPID keys are not configured. Cannot send push notification."
      return false
    end

    Webpush.payload_send(
      message: payload.to_json,
      endpoint: subscriber.endpoint,
      p256dh: subscriber.p256dh,
      auth: subscriber.auth,
      vapid: {
        subject: "mailto:admin@example.com",
        public_key: public_key,
        private_key: private_key
      }
    )
    
    true
  rescue StandardError => e
    Rails.logger.error "WebPush error for subscriber #{subscriber.id}: #{e.message}"
    false
  end
end
