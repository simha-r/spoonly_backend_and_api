require 'api_constraints'

Rails.application.routes.draw do


  devise_for :company_users
  devise_for :users, controllers: { omniauth_callbacks: "customer/omniauth_callbacks" }
  root to: 'customer/menus#home'


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

    resources :line_items,only: [:create]

    resources :orders,only:[:new,:create] do
        collection do
          get :success
        end
    end

    resource :number_verifications,only:[] do
      post :start
      post :finish
    end

  end

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1,default: true) do
      resources :products do
        collection do
          get :lunch
        end
      end
      resources :line_items
      resources :orders
      resources :sessions
      resource :wallets,only:[:show]
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
    end

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
  end

end
