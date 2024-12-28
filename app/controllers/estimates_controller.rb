class EstimatesController < ApplicationController
  def index
    @q = Estimate.ransack(params[:q])
    @estimates = @q.result.order(created_at: :desc)
    @estimates_for_view = @estimates.page(params[:page]).per(100)
  end

  def new
    @estimate = Estimate.new
  end

  def confirm
    @estimate = Estimate.new(estimate_params)

    check_in_date = @estimate.check_in_date.to_date
    check_out_date = @estimate.check_out_date.to_date

    result = PriceCalculator.calculate_total_price(check_in_date, check_out_date)

    if result[:error]
      flash[:error] = result[:error]
      render :new and return
    end

    @num_normal_days = result[:normal_days]
    @num_peak_days = result[:peak_days]
    @total_price = result[:total_price]
    @normal_price_per_night = result[:normal_price_per_night]
    @peak_price_per_night = result[:peak_price_per_night]
    @initial_cost = result[:initial_cost] # 初期費用

    if @estimate.valid?
      render :confirm
    else
      render :new
    end
  end

  def thanks
    if params[:estimate] # パラメータがある場合
      @estimate = Estimate.new(estimate_params)
      if @estimate.save
        # メールを送信
        EstimateMailer.received_email(@estimate).deliver
        EstimateMailer.send_email(@estimate).deliver
      end
    else
      # パラメータがない場合はダミーデータで対応
      @estimate = Estimate.new(name: "ゲスト", tel: "未提供", email: "未提供")
    end
  end
  
  def create
    @estimate = Estimate.new(estimate_params)
    @estimate.save
    redirect_to thanks_estimates_path
  end

  def show
    @estimate = Estimate.find_by(id: params[:id])
  end


  def edit
    @estimate = Estimate.find(params[:id])
  end

  def destroy
    @estimate = Estimate.find(params[:id])
    @estimate.destroy
    redirect_to estimates_path, alert:"削除しました"
  end

  def update
    @estimate = Estimate.find(params[:id])
    if @estimate.update(estimate_params)
      redirect_to estimates_path(@estimate), alert: "更新しました"
    else
      render 'edit'
    end
  end

  private
  
  def estimate_params
    params.require(:estimate).permit(
      :name,  #名前
      :tel, #電話番号
      :email, #メールアドレス
      :postnumber, #郵便番号
      :address, #住所
      :people, #屋内の場合、使用が想定される人数
      :check_in_date, #設置箇所
      :check_out_date,
      :remarks #要望
    )
  end
end
