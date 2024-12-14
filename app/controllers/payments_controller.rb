class PaymentsController < ApplicationController
  require 'square'
  require 'securerandom'
  require 'bigdecimal'

  before_action :set_estimate, only: [:checkout]

  def checkout
    if @estimate.nil?
      Rails.logger.info("対象の見積もりが存在しません。")
      redirect_to cancel_url
      return
    end

    check_in_date = @estimate.check_in_date
    check_out_date = @estimate.check_out_date

    result = PriceCalculator.calculate_total_price(check_in_date, check_out_date)

    if result[:error]
      flash[:error] = result[:error]
      redirect_to cancel_url
      return
    end

    total_price = result[:total_price]

    client = Square::Client.new(
      access_token: ENV['SQUARE_TOKEN'],
      environment: ENV['SQUARE_ENV']
    )

    result = client.checkout.create_payment_link(
      body: {
        idempotency_key: SecureRandom.uuid,
        quick_pay: {
          name: "estimateId:#{@estimate.id}",
          price_money: {
            amount: BigDecimal(total_price.to_s).ceil.to_i,
            currency: "JPY"
          },
          location_id: ENV['SQUARE_LOCATION_ID']
        },
        checkout_options: {
          redirect_url: success_url(estimate_id: @estimate.id)
        }
      }
    )

    if result.success?
      payment_link = result.data[:payment_link][:url]
      Rails.logger.info("決済リンク: #{payment_link}, Estimate ID: #{@estimate.id}")
      redirect_to payment_link
    else
      Rails.logger.error("決済に失敗しました。: #{result.errors}, Estimate ID: #{@estimate.id}")
      redirect_to cancel_url
    end
  end

  def thanks
    # 支払い成功時の処理
  end

  def cancel
    # 支払いキャンセル時の処理
  end

  private

  def set_estimate
    @estimate = Estimate.find(params[:estimate_id])
  end
end
