class TopController < ApplicationController
  before_action :redirect_based_on_device, only: [:index, :lp, :index_en, :lp_en]
  def index
  end

  def lp
  end

  def index_en
  end

  def lp_en
  end

  def calculate_price
    begin
      check_in_date = params[:check_in_date].to_date
      check_out_date = params[:check_out_date].to_date
    rescue ArgumentError
      render json: { error: "日付の形式が正しくありません。" }, status: :unprocessable_entity
      return
    end

    result = PriceCalculator.calculate_total_price(check_in_date, check_out_date)
    render json: result
  end

  def cancalpolicy
  end

  def privacy
  end
  private

  # デバイスに応じてリダイレクトする
  def redirect_based_on_device
    if request.user_agent =~ /Mobile|Android|iPhone/
      case action_name
      when 'lp'
        redirect_to action: 'index' # スマホ用にリダイレクト
      when 'lp_en'
        redirect_to action: 'index_en'
      end
    else
      case action_name
      when 'index'
        redirect_to action: 'lp' # PC用にリダイレクト
      when 'index_en'
        redirect_to action: 'lp_en'
      end
    end
  end
end
