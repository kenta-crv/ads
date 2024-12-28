class MonthsController < ApplicationController
    def index
      @q = Month.ransack(params[:q])
      @months = @q.result.order(created_at: :desc)
      @months_for_view = @months.page(params[:page]).per(100)
    end
  
    def new
      @month = Month.new
    end
  
    def confirm
        @month = Month.new(month_params)
      
        check_in_date = @month.check_in_date.to_date
        check_out_date = @month.check_out_date.to_date
      
        # マンスリーモードで料金を計算
        result = PriceCalculator.calculate_total_price(check_in_date, check_out_date, mode: :monthly)
      
        if result[:error]
          flash[:error] = result[:error]
          render :new and return
        end
      
        @num_normal_days = result[:normal_days]
        @total_price = result[:total_price]
        @normal_price_per_night = result[:normal_price_per_night]
        @initial_cost = result[:initial_cost]
      
        if @month.valid?
          render :confirm
        else
          render :new
        end
      end
      

    def thanks
      if params[:month] # パラメータがある場合
        @month = Month.new(month_params)
        if @month.save
          # メールを送信
          MonthMailer.received_email(@month).deliver
          MonthMailer.send_email(@month).deliver
        end
      else
        # パラメータがない場合はダミーデータで対応
        @month = Month.new(name: "ゲスト", tel: "未提供", email: "未提供")
      end
    end
    
    def create
      @month = Month.new(month_params)
      @month.save
      redirect_to thanks_months_path
    end
  
    def show
      @month = Month.find_by(id: params[:id])
    end
  
  
    def edit
      @month = Month.find(params[:id])
    end
  
    def destroy
      @month = Month.find(params[:id])
      @month.destroy
      redirect_to months_path, alert:"削除しました"
    end
  
    def update
      @month = Month.find(params[:id])
      if @month.update(month_params)
        redirect_to months_path(@month), alert: "更新しました"
      else
        render 'edit'
      end
    end

    private
    
    def month_params
      params.require(:month).permit(
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
  