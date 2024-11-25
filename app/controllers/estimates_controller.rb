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
    
      # 宿泊日数と料金計算
      check_in_date = @estimate.check_in_date
      check_out_date = @estimate.check_out_date
    
      if check_in_date.nil? || check_out_date.nil?
        flash[:error] = "チェックイン日またはチェックアウト日が入力されていません。"
        render :new and return
      end
    
      num_days = (check_out_date - check_in_date).to_i
    
      if num_days < 5
        flash[:error] = "宿泊日数は最低5泊以上必要です。"
        render :new and return
      end
    
      # サービスで料金計算を行う
      result = PriceCalculator.calculate_total_price(check_in_date, check_out_date)
    
      @normal_price_per_night = PriceCalculator::NORMAL_PRICE_PER_NIGHT
      @peak_price_per_night = PriceCalculator::PEAK_PRICE_PER_NIGHT
      @num_normal_days = result[:normal_days]
      @num_peak_days = result[:peak_days]
      @total_price = result[:total_price]
    
      add_breadcrumb "入力内容確認"
      if @estimate.valid?
        render :action => 'confirm'
      else
        render :action => 'new'
      end
    end
    
    
    def calculate_total_price(check_in_date, check_out_date, num_days)
      num_normal_days = 0
      num_peak_days = 0
    
      # 宿泊日ごとに繁忙期か通常期かを判定
      (0...num_days).each do |i|
        current_date = check_in_date + i.days
        if peak_season?(current_date)
          num_peak_days += 1
        else
          num_normal_days += 1
        end
      end
    
      total_price = (num_normal_days * @normal_price_per_night) + (num_peak_days * @peak_price_per_night)
      return num_normal_days, num_peak_days, total_price
    end
    
    def peak_season?(date)
      peak_seasons = [
        (Date.new(date.year, 12, 20)..Date.new(date.year + 1, 1, 10)),
        (Date.new(date.year, 1, 25)..Date.new(date.year, 2, 10)),
        (Date.new(date.year, 3, 20)..Date.new(date.year, 4, 10)),
        (Date.new(date.year, 4, 28)..Date.new(date.year, 5, 10)),
        (Date.new(date.year, 7, 1)..Date.new(date.year, 8, 31))
      ]
    
      peak_seasons.any? { |season| season.cover?(date) }
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
    
      normal_price_per_night = 55000.00
      peak_price_per_night = 88000.00
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
  