Rails.application.routes.draw do
  root to: 'top#index' # クライアント側トップ
  get "/lp" => 'top#lp' # ユーザー側トップ
  get "/privacy" => 'top#privacy' # ユーザー側トップ
  get "/cancalpolicy" => 'top#cancalpolicy' # ユーザー側トップ
  get 'top/calculate_price', to: 'top#calculate_price'
  # 管理者アカウント
  devise_for :admins, controllers: {
    registrations: 'admins/registrations',
    sessions: 'admins/sessions'
  }
  resources :admins, only: [:show]

  # クライアントアカウント
  devise_for :clients, controllers: {
    registrations: 'clients/registrations',
    sessions: 'clients/sessions'
  }
  resources :clients do
    resources :offers do
      member do
        get 'confirm'
        post 'thanks'
      end
    end
    resource :comments
    collection do
      post :confirm
      post :thanks
    end
    member do
      post :send_mail
      post :send_mail_start
      get "info"
      get "conclusion"
      get "payment"
      get "calendar"
      get "start"
    end
  end

  # ユーザーアカウントとワーカーリソース
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :users do
    resources :offers do
      member do
        get 'confirm'
        post 'thanks'
      end
    end
    resource :comments
    collection do
      post :confirm
      post :thanks
    end
    member do
      post :send_mail
      post :send_mail_start
      get "info"
      get "conclusion"
      get "payment"
      get "calendar"
      get "start"
      post 'offer_email', to: 'workers#offer_email', as: 'offer_email'
      post 'reject_email', to: 'workers#reject_email', as: 'reject_email'
   end
  end

  post 'checkout', to: 'payments#checkout'
  get 'success', to: 'payments#success'
  get 'cancel', to: 'payments#cancel'

  resources :estimates do
    collection do
      post :confirm
      post :thanks
    end
  end

  resources :offers, only: [:index, :show]
end
