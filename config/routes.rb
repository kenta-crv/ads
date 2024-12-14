Rails.application.routes.draw do
  root to: 'top#index' # クライアント側トップ
  get "/lp" => 'top#lp' # ユーザー側トップ
  get "/privacy" => 'top#privacy' # ユーザー側トップ
  get "/cancalpolicy" => 'top#cancalpolicy' # ユーザー側トップ
  get 'top/calculate_price', to: 'top#calculate_price'

  get "/lp_en" => 'top#lp_en'
  get "/index_en" => 'top#index_en'
  
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
      get :thanks
    end
  end

  resources :contacts do
    collection do
      post :confirm
      post :thanks
    end
  end

end
