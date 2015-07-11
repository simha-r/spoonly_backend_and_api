require 'api_constraints'

Rails.application.routes.draw do


  devise_for :company_users
  devise_for :users, controllers: { omniauth_callbacks: "customer/omniauth_callbacks" }
  root to: 'customer/homes#main'


  namespace :customer do

    resources :homes do
      collection do
        get :main
        post :inside
      end
    end

    resources :products do
      collection do
        get :home
        get :lunch
      end
    end

    resources :line_items,only: [:create]

    resources :orders,only:[:new,:create] do
      collection do
        get :new_trial
      end
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
    end

  end

  namespace :company do
    resources :products
  end

end
