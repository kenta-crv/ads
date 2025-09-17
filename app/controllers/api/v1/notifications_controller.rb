module Api
  module V1
    class NotificationsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        subscribers = Subscriber.all
        payload = {
          title: params[:title] || "New Notification",
          body: params[:body] || "Default body",
          url: params[:url] || "/"
        }

        successes = 0
        subscribers.find_each do |subscriber|
          if WebPushService.send_notification(subscriber, payload)
            successes += 1
          end
        end

        render json: { status: "ok", delivered: successes, total: subscribers.count }
      end
    end
  end
end
