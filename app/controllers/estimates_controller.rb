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
      @estimate = Estimate.new(estimate_params)
      @estimate.save
      EstimateMailer.received_email(@estimate).deliver # 管理者に通知
      EstimateMailer.send_email(@estimate).deliver # 送信者に通知
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
    def calculate_total_price(check_in_date, check_out_date, num_days)
      # 繁忙期の定義
      peak_seasons = [
        (Date.new(check_in_date.year, 12, 20)..Date.new(check_in_date.year + 1, 1, 10)),
        (Date.new(check_in_date.year, 1, 25)..Date.new(check_in_date.year, 2, 10)),
        (Date.new(check_in_date.year, 3, 20)..Date.new(check_in_date.year, 4, 10)),
        (Date.new(check_in_date.year, 4, 28)..Date.new(check_in_date.year, 5, 10)),
        (Date.new(check_in_date.year, 7, 1)..Date.new(check_in_date.year, 8, 31))
      ]
    
      normal_price_per_night = 39500.00
      peak_price_per_night = 55000.00
      total_price = 0
      num_normal_days = 0
      num_peak_days = 0
    
      # 各日をチェックして繁忙期か通常期かを判定し、日ごとの料金を計算
      num_days.times do |i|
        current_date = check_in_date + i.days
        is_peak_day = peak_seasons.any? { |season| season.cover?(current_date) }
    
        if is_peak_day
          total_price += peak_price_per_night
          num_peak_days += 1
        else
          total_price += normal_price_per_night
          num_normal_days += 1
        end
      end
    
      [num_normal_days, num_peak_days, total_price]
    end
    
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
  