Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  get 'answer/index'
  get 'answer/edit'
  get 'answer/show'
  get 'option/index'
  get 'option/show'
  get 'option/create'
  get 'option/edit'
  get 'option/update'
  get 'notes/index'
  # get 'courses/:course_id/test/index', to: 'test#index'
  # get 'test/index/courseId' to: 'test#new'
  get 'home/index'
  # get 'preview' to: 'notes#preview'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :courses do
    resources :test do
      resources :question do
        resources :option
      end
    end
    resources :notes 
  end
  # Defines the root path route ("/")
  root "home#index"
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions'
  # }
end