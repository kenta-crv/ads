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

    # サービスで料金計算を行う
    result = PriceCalculator.calculate_total_price(check_in_date, check_out_date)

    if result[:error]
      flash[:error] = result[:error]
      redirect_to cancel_url
      return
    end

    total_price = result[:total_price]

    # Square APIを使用してCheckoutを作成
    client = Square::Client.new(
      access_token: ENV['SQUARE_TOKEN'],
      environment: ENV['SQUARE_ENV']
    )

    result = client.checkout.create_payment_link(
      body: {
        idempotency_key: SecureRandom.uuid,
        quick_pay: {
          name: "estimateId:#{@estimate.id}", # 見積もりID
          price_money: {
            amount: BigDecimal(total_price.to_s).ceil.to_i, # `total_price` を `BigDecimal` 型に変換し、小数点以下を切り上げて整数に変換
            currency: "JPY"
          },
          location_id: ENV['SQUARE_LOCATION_ID']
        },
        checkout_options: {
          redirect_url: success_url(estimate_id: @estimate.id) # 決済成功時のリダイレクトURL
        }
      }
    )

    if result.success?
      # 生成されたリンクを取得
      payment_link = result.data[:payment_link][:url]
      Rails.logger.info("決済リンク: #{payment_link}, Estimate ID: #{@estimate.id}")
      redirect_to payment_link
    else
      # エラー処理
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

  # 繁忙期の料金を計算するメソッド
  def calculate_total_price(check_in_date, check_out_date, num_days)
    # 繁忙期の複数期間を定義
    peak_seasons = [
      (Date.new(check_in_date.year, 12, 20)..Date.new(check_in_date.year + 1, 1, 10)),
      (Date.new(check_in_date.year, 1, 25)..Date.new(check_in_date.year, 2, 10)),
      (Date.new(check_in_date.year, 3, 20)..Date.new(check_in_date.year, 4, 10)),
      (Date.new(check_in_date.year, 4, 28)..Date.new(check_in_date.year, 5, 10)),
      (Date.new(check_in_date.year, 7, 1)..Date.new(check_in_date.year, 8, 31))
    ]

    # 繁忙期かどうかを判定
    is_peak_season = peak_seasons.any? do |season|
      (check_in_date >= season.first && check_in_date <= season.last) || 
      (check_out_date >= season.first && check_out_date <= season.last)
    end

    price_per_night = is_peak_season ? 88000.00 : 55000.00 # 繁忙期料金と通常料金を設定
    total_price = num_days * price_per_night
    total_price
  end
end
