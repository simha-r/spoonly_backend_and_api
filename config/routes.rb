require 'api_constraints'

Rails.application.routes.draw do


  devise_for :company_users
  devise_for :users, controllers: { omniauth_callbacks: "customer/omniauth_callbacks",sessions: 'customer/sessions',
                                    passwords: 'customer/passwords' }
  root to: 'customer/homes#main'
  get '/app',to: 'customer/homes#app'

  namespace :customer do

    resources :homes do
      collection do
        get :main
        post :inside
        get :android
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
      resource :accounts,only:[:show] do
        put :update
      end
      resource :menu do
        get :lunch
        get :dinner
      end
      resource :number_verifications,only:[] do
        post :start
        get :resend
        post :finish
      end
      resources :addresses,only:[:index,:create,:update,:destroy]
      resources :feedbacks,only:[:create]
      resources :referrals,only: [:create]
      resource :promotions,only:[] do
        get :referral
      end
    end
    # Moved it out of the first namespace because of instamojo redirect..has no headers



  end

  # Have to manually specify mapping because traccars sends a port number
  get "/company/delivery_executives/update_location:80" => "company/delivery_executives#update_location"

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
        put :inform_delivery_guy
        put :withdraw_delivery_request
        put :cancel
        put :deliver
        get :bill
        put :ask_feedback
      end
      collection do
        post :sms_update
        get :by_date
        get :collections_summary
      end
    end
    resources :current_orders do
      collection do
        get :pending
        get :acknowledged
        get :dispatched
        get :delivered
        get :cancelled
        get :chef_summary
        post :multi_assign
        get :heatmap
      end
    end
    resources :company_users do
      member do
        put :enable_otp
        put :disable_otp
        get :show_otp
      end
    end
    resources :delivery_executives do
      member do
        put :mark_available
        get :show_location
        get :test_device
      end
      get :live_view,on: :collection
      get :dashboard,on: :collection
    end
    resources :general_promotions do
      member do
        put :enable
        put :disable
        post :apply
      end
    end
    resources :growth_partners

    resources :wallet_promotions do

    end
    resources :referrals
    resources :card_transactions,only: [:show,:index] do
    end
    resources :users do
      member do
        get :wallet
        post :give_money
      end
    end
    resources :feedbacks
    namespace :field do
      resources :orders do
        member do
          put :accept
          put :reject
          put :mark_delivered
        end
      end
    end
  end
  resources :sitemaps, :only => :show
  get "sitemap" => "sitemaps#show"
  resources :gifts,only: [:show] do
  end

end