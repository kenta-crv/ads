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
      add_breadcrumb "入力内容確認"
      if @estimate.valid?
        render :action =>  'confirm'
      else
        render :action => 'new'
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
  