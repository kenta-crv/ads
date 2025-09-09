class DeliversController < ApplicationController
    def index
      @delivers = Deliver.order(created_at: "DESC").page(params[:page])
    end
  
    def show
      @deliver = Deliver.find(params[:id])
      @delivers = @client.delivers.order(created_at: :desc)
    end

    def new
      @client = Client.find(params[:client_id])
      @deliver = @client.delivers.new
    end

      
def confirm
  @client = Client.find(params[:client_id])
  @deliver = @client.delivers.new(deliver_params)
  if @deliver.valid?
    render :confirm
  else
    render :new
  end
end

    def create
      @client = Client.find(params[:client_id])
      @client.delivers.create(deliver_params)
      redirect_to client_path(@client)
    end

  def thanks
    if params[:client] # パラメータがある場合
      @client = Client.new(client_params)
      if @client.save
        # メールを送信
        #clientMailer.received_email(@client).deliver
        #clientMailer.send_email(@client).deliver
      end
    end
  end


    def destroy
      @client = Client.find(params[:client_id])
      @deliver = @client.delivers.find(params[:id])
      @deliver.destroy
      redirect_to client_path(@client)
    end

    def edit
      @client = Client.find(params[:client_id])
      @deliver = @client.delivers.find(params[:id])
    end
  
    def update
        @client = Client.find(params[:client_id])
        @deliver = @client.delivers.find(params[:id])
       if @deliver.update(deliver_params)
         redirect_to client_path(@client)
       else
          render 'edit'
       end
    end

    private
    def deliver_params
      params.require(:deliver).permit(:title, :image, :body, :count, :reservation)
  end
end
