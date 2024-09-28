require 'paypal-checkout-sdk'
class PaymentsController < ApplicationController
    before_action :set_estimate, only: [:checkout, :success, :cancel]
  
    def checkout
      # チェックイン日とチェックアウト日から日数を計算
      check_in_date = @estimate.check_in_date
      check_out_date = @estimate.check_out_date
  
      estimate = Estimate.find(params[:estimate_id])
      num_days = (estimate.check_out_date - estimate.check_in_date).to_i
      price_per_night = 55000.00 # 1泊あたりの金額
      total_price = num_days * price_per_night
  
      request = PayPalCheckoutSdk::Orders::OrdersCreateRequest.new
      request.prefer('return=representation')
      request.request_body({
        intent: 'CAPTURE',
        purchase_units: [{
          amount: {
            currency_code: 'JPY',
            value: total_price.to_s # 動的に計算された支払い金額
          }
        }],
        application_context: {
          return_url: success_url,
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
  
    # 支払い成功時の処理
    def success
      order_id = params[:token] # PayPalから返されるトークンで注文IDを取得
      request = PayPalCheckoutSdk::Orders::OrdersCaptureRequest.new(order_id)
      
      begin
        response = PayPalClient.client.execute(request)
        if response.result.status == "COMPLETED"
          @estimate.update(payment_status: "completed")
          flash[:notice] = "支払いが完了しました"
          redirect_to estimate_path(@estimate)
        else
          flash[:alert] = "支払いが失敗しました"
          redirect_to estimate_path(@estimate)
        end
      rescue PayPalHttp::HttpError => e
        render plain: e.status_code
      end
    end
  
    # 支払いキャンセル時の処理
    def cancel
      flash[:alert] = "支払いがキャンセルされました"
      redirect_to estimate_path(@estimate)
    end
  
    private
  
    def set_estimate
      @estimate = Estimate.find(params[:estimate_id])
    end
  end
  