class ContactsController < ApplicationController
      def index
        @contacts = Contact.order(created_at: "DESC").page(params[:page])
      end
    
      def new
        @contact = Contact.new
      end
    
      def confirm
        @contact = Contact.new(contact_params)
      end
    
      def thanks
        @contact = Contact.new(contact_params)
        @contact.save
        ContactMailer.received_email(@contact).deliver # 管理者に通知
        ContactMailer.send_email(@contact).deliver # 送信者に通知
      end
    
      def create
        @contact = Contact.new(contact_params)
        @contact.save
        redirect_to thanks_contacts_path
      end
    
      def show
        @contact = Contact.find(params[:id])
        @comment = Comment.new
      end

      def destroy
        @contact = Contact.find(params[:id])
        @contact.destroy
        redirect_to contacts_path, alert:"削除しました"
      end
    
      private
      def contact_params
        params.require(:contact).permit(
           :name,
           :tel,
           :email,
           :messages,
        )
      end
  end
  