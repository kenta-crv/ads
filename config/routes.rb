Rails.application.routes.draw do
  root to: 'top#index' # クライアント側トップ
  get "/lp" => 'top#lp' # ユーザー側トップ
  get "/privacy" => 'top#privacy' # ユーザー側トップ
  get "/cancelpolicy" => 'top#cancelpolicy' # ユーザー側トップ
  get 'top/calculate_price', to: 'top#calculate_price'

  get "/lp_en" => 'top#lp_en'
  get "/index_en" => 'top#index_en'
  
  get "/monthly" => 'top#monthly'
  get "/weekly" => 'top#weekly'
  get "/test_push" => 'top#test_push'
  get "/push_demo" => 'top#push_demo'
  
  # クライアントアカウント
  devise_for :clients, controllers: {
    registrations: 'clients/registrations',
    sessions: 'clients/sessions',
    passwords: 'clients/passwords'
  }
  resources :clients, except: [:new, :create] do
    resources :comments 
    collection do
      post :confirm
      post :thanks
    end
    resources :delivers do
      collection do
        post :confirm
      end
    end
    member do
      post :send_mail
      post :send_mail_start
      get "conclusion"
    end
  end

  
  # 管理者アカウント
  devise_for :admins, controllers: {
    registrations: 'admins/registrations',
    sessions: 'admins/sessions'
  }
  resources :admins, only: [:show]

  # Square（決済）
  post 'checkout', to: 'payments#checkout'
  get 'success', to: 'payments#success'
  get 'cancel', to: 'payments#cancel'

  resources :estimates do
    resources :delivers do
      collection do
        post :confirm
      end
    end
    collection do
      post :confirm
    end
  end



  resources :contacts do
    collection do
      post :confirm
      post :thanks
    end
  end

  namespace :api do
    namespace :v1 do
      resources :subscribers, only: [:create]
      resources :notifications, only: [:create]
      get "embed.js", to: "embed#show"
    end
  end

end
