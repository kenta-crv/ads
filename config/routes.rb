Rails.application.routes.draw do
  root to: 'top#index' # クライアント側トップ
  get "/lp" => 'top#lp' # ユーザー側トップ
  get "/privacy" => 'top#privacy' # ユーザー側トップ
  get "/cancalpolicy" => 'top#cancalpolicy' # ユーザー側トップ
  get 'top/calculate_price', to: 'top#calculate_price'

  get "/lp_en" => 'top#lp_en'
  get "/index_en" => 'top#index_en'
  
  get "/monthly" => 'top#monthly'
  get "/weekly" => 'top#weekly'
  

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
    collection do
      post :confirm
      post :thanks  # フォーム送信時のPOSTを維持
      get :thanks   # Google広告や直接アクセス用のGETを追加
    end
  end

  resources :weeks do
    collection do
      post :confirm
      post :thanks  # フォーム送信時のPOSTを維持
      get :thanks   # Google広告や直接アクセス用のGETを追加
    end
  end

  resources :months do
    collection do
      post :confirm
      post :thanks  # フォーム送信時のPOSTを維持
      get :thanks   # Google広告や直接アクセス用のGETを追加
    end
  end

  resources :contacts do
    collection do
      post :confirm
      post :thanks
    end
  end

end
