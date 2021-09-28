Rails.application.routes.draw do

  get 'posts/new'
  get 'posts/create'
  get 'posts/show'
  get 'posts/index'
  get 'comments/new'
  get 'comments/create'
  get 'comments/show'
  root to: 'posts#index'
  resources :posts, only: [:new, :create, :index, :show] do
    resources :comments, only: [:new, :show, :create]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
