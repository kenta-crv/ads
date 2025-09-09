# frozen_string_literal: true

class Clients::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    @client = Client.new(sign_up_params)

    if @client.save
      # ログイン
      sign_in(@client)
      # 管理者でなければメール送信
      unless admin_signed_in?
         ClientMailer.received_email(@client).deliver
         ClientMailer.send_email(@client).deliver
      end
      redirect_to client_path
    else
      render 'clients/registrations/new'
    end
  end

  protected

  def after_update_path_for(resource)
    client_path(id: resource.id)
  end

  private

  def configure_permitted_parameters
    added_attrs = [
      :user_name, :select,
      :company, :post_title, :representative_name, :contact_name, :tel, :email, :address, :url, :message,
      :recruit_url, :visa, :business, :genre, :salary, :work_time, :day_off, :work_contents, :number,
      :house_agents, :house_support, :remarks, :total_price,
      :agree, :contract_date, :plan
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
