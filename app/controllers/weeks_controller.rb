class WeeksController < ApplicationController
    def index
      @q = Week.ransack(params[:q])
      @weeks = @q.result.order(created_at: :desc)
      @weeks_for_view = @weeks.page(params[:page]).per(100)
    end
  
    def new
      @week = Week.new
    end
  
    def confirm
        @week = Week.new(week_params)
      
        check_in_date = @week.check_in_date.to_date
        check_out_date = @week.check_out_date.to_date
      
        # ウィークリーモードで料金を計算
        result = PriceCalculator.calculate_total_price(check_in_date, check_out_date, mode: :weekly)
      
        if result[:error]
          flash[:error] = result[:error]
          render :new and return
        end
      
        @num_normal_days = result[:normal_days]
        @total_price = result[:total_price]
        @normal_price_per_night = result[:normal_price_per_night]
        @initial_cost = result[:initial_cost]
      
        if @week.valid?
          render :confirm
        else
          render :new
        end
      end

    def thanks
      if params[:week] # パラメータがある場合
        @week = Week.new(week_params)
        if @week.save
          # メールを送信
          WeekMailer.received_email(@week).deliver
          WeekMailer.send_email(@week).deliver
        end
      else
        # パラメータがない場合はダミーデータで対応
        @week = Week.new(name: "ゲスト", tel: "未提供", email: "未提供")
      end
    end
    
    def create
      @week = Week.new(week_params)
      @week.save
      redirect_to thanks_weeks_path
    end
  
    def show
      @week = Week.find_by(id: params[:id])
    end
  
  
    def edit
      @week = Week.find(params[:id])
    end
  
    def destroy
      @week = Week.find(params[:id])
      @week.destroy
      redirect_to weeks_path, alert:"削除しました"
    end
  
    def update
      @week = Week.find(params[:id])
      if @week.update(week_params)
        redirect_to weeks_path(@week), alert: "更新しました"
      else
        render 'edit'
      end
    end

    private    
    def week_params
      params.require(:week).permit(
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
  