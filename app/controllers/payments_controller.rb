class PaymentsController < ApplicationController
  before_action :set_estimate, only: [:checkout]

  def checkout
    check_in_date = @estimate.check_in_date
    check_out_date = @estimate.check_out_date
  
    num_days = (check_out_date - check_in_date).to_i
    total_price = calculate_total_price(check_in_date, check_out_date, num_days)
  
    request = PayPalCheckoutSdk::Orders::OrdersCreateRequest.new
    request.prefer('return=representation')
    request.request_body({
      intent: 'CAPTURE',
      purchase_units: [{
        amount: {
          currency_code: 'JPY',
          value: total_price.to_s
        }
      }],
      application_context: {
        return_url: success_url(estimate_id: @estimate.id),
        cancel_url: cancel_url
      }
    })
  
    begin
      response = PayPalClient.client.execute(request)
      redirect_to response.result.links.find { |v| v.rel == 'approve' }.href
    rescue PayPalHttp::HttpError => e
      render plain: e.status_code
    end
  end
  

  def success
    # 支払い成功時の処理
    # ここで必要な処理を追加できます。例えば、データベースの更新や購入完了ページへのリダイレクトなど。
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

    price_per_night = is_peak_season ? 88000.00 : 1.00 # 繁忙期料金と通常料金を設定
    total_price = num_days * price_per_night
    total_price
  end
end
