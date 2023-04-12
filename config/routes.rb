Rails.application.routes.draw do
  resources :url_changes, only: [:index, :create, :show]
  root to: 'url_changes#index'
end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

