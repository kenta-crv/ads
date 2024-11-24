class TopController < ApplicationController

  def index
    if pc_device?
      redirect_to lp_path
    else
      # スマホの場合はそのまま index を表示
      render :index
    end
  end

  def lp
    # PC専用のランディングページ表示処理
    render :lp
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
end
