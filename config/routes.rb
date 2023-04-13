# frozen_string_literal: true

Rails.application.routes.draw do
  get 'page/home'
  use_doorkeeper
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'testresult/index'
  get 'testresult/show'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # get 'testresult/index', to: 'testresult#index', as: :testresult_ind
  delete 'testresult/:testresult_id', to: 'testresult#destroy', as: :testresult_destroy
  get 'answer/index'
  get 'answer/edit'
  get 'answer/show'
  get 'option/index'
  get 'option/show'
  get 'option/create'
  get 'option/edit'
  get 'option/update'
  get 'notes/index'
  # get 'test/index/courseId' to: 'test#new'
  get 'home/index'
  # get 'preview' to: 'notes#preview'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :courses do
    get '/enroll', to: 'courses#enroll', on: :member
    get '/drop', to: 'courses#drop', on: :member
    resources :test do
      resources :question do
        resources :option
      end
      resources :testresult
    end
    resources :notes
  end
  # Defines the root path route ("/")
  root 'courses#index'
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions'
  # }

  namespace :api, default: { format: :json } do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    get 'testresult/index'
    get 'testresult/show'
    devise_for :users, controllers: {
      registrations: 'api/users/registration'
    }
    get 'testresult/index'
    get 'answer/index'
    get 'answer/edit'
    get 'answer/show'
    get 'option/index'
    get 'option/show'
    get 'option/create'
    get 'option/edit'
    get 'option/update'
    get 'notes/index'
    # get 'test/index/courseId' to: 'test#new'
    get 'home/index'
    # get 'preview' to: 'notes#preview'
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    resources :courses do
      get '/enroll', to: 'courses#enroll', on: :member
      get '/drop', to: 'courses#drop', on: :member
      resources :test do
        resources :question do
          resources :option
        end
        resources :testresult
      end
      resources :notes
    end
    # Defines the root path route ("/")
    root 'courses#index'
    # devise_for :users, controllers: {
    #   sessions: 'users/sessions'
    # }
  end
end
