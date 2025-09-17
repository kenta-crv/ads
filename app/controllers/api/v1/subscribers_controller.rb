module Api
  module V1
    class SubscribersController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        Rails.logger.info "Subscriber params: #{params.inspect}"
        
        subscriber = Subscriber.find_or_initialize_by(endpoint: params[:endpoint])
        subscriber.assign_attributes(
          p256dh: params.dig(:keys, :p256dh),
          auth: params.dig(:keys, :auth),
          browser: params[:browser],
          user_agent: request.user_agent
        )

        Rails.logger.info "Subscriber attributes: #{subscriber.attributes.inspect}"

        if subscriber.save
          Rails.logger.info "Subscriber saved successfully: #{subscriber.id}"
          render json: { status: 'ok', subscriber_id: subscriber.id }, status: :created
        else
          Rails.logger.error "Subscriber save failed: #{subscriber.errors.full_messages}"
          render json: { errors: subscriber.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
