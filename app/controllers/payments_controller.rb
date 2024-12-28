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

    # 適切なモードで料金計算を実行
    model_type = params[:model_type] || 'Estimate'
    mode = case model_type
           when 'Estimate' then :estimate
           when 'Month' then :monthly
           when 'Week' then :weekly
           else
             redirect_to cancel_url, alert: "無効なモデルタイプです。"
             return
           end

    result = PriceCalculator.calculate_total_price(check_in_date, check_out_date, mode: mode)

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
          redirect_url: success_url(estimate_id: @estimate.id, model_type: model_type)
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
    # リクエストからモデルタイプを判別
    model_type = params[:model_type] || 'Estimate'
    model_id = params[:id] || params[:estimate_id] # IDの取得を柔軟に

    # 適切なモデルクラスを取得
    case model_type
    when 'Estimate'
        @estimate = Estimate.find_by(id: model_id)
    when 'Month'
        @estimate = Month.find_by(id: model_id)
    when 'Week'
        @estimate = Week.find_by(id: model_id)
    else
      raise ActiveRecord::RecordNotFound, "Invalid model type: #{model_type}"
    end
  end
end
