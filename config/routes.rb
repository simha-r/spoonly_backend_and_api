require 'api_constraints'

Rails.application.routes.draw do


  devise_for :company_users
  devise_for :users, controllers: { omniauth_callbacks: "customer/omniauth_callbacks",sessions: 'customer/sessions',
                                    passwords: 'customer/passwords' }
  root to: 'customer/homes#main'


  namespace :customer do

    resources :homes do
      collection do
        get :main
        post :inside
      end
    end

    resources :menus do
      collection do
        get :home
        get :lunch
        get :dinner
      end
    end

    resources :line_items,only: [:create,:destroy] do
      member do
        put :decrease_count
      end
    end

    resources :orders,only:[:new,:create] do
        member do
          get :success
        end
    end

    resource :number_verifications,only:[] do
      post :start
      post :finish
    end

    resource :account,only:[:show]

    resources :addresses

    resource :wallet,only:[:show] do
      get :recharge
      get :add_money
      get :successful_recharge
      get :failed_recharge
    end

    namespace :app do
      resource :wallet do
        get :recharge
        get :successful_recharge
        get :failed_recharge
      end
    end

  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resource :wallet do
        get :recharge
      end
    end
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      resources :products do
        collection do
          get :lunch
        end
      end
      resources :line_items
      resources :orders
      resources :sessions
      resource :wallet,only:[:show] do
        get :recharge
        post :recharge
      end
      resource :accounts,only:[:show]
      resource :menu do
        get :lunch
        get :dinner
      end
      resource :number_verifications,only:[] do
        post :start
        post :finish
      end
      resources :addresses,only:[:index,:create,:update,:destroy]
      resources :feedbacks,only:[:create]
      resources :referrals,only: [:create]
    end
    #TODO Moved it out of the first namespace because of instamojo redirect..has no headers



  end

  namespace :company do
    root 'homes#home'
    resources :homes
    resources :products
    resources :menus do
      member do
        get :add_items
      end
    end
    resources :menu_products,only: [:create,:update,:destroy]
    resources :orders,only:[:index,:show] do
      member do
        put :acknowledge
        put :assign
      end
      collection do
        post :sms_update
      end
    end
    resources :users do
      member do
        put :enable_otp
        put :disable_otp
      end
    end
  end

  resources :sitemaps, :only => :show
  get "sitemap" => "sitemaps#show"

end
