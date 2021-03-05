Rails.application.routes.draw do
  get 'favorites/create'
  get 'favorites/destroy'
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions' }

  root to: "homes#top"
  get "home/about" => "homes#about"

  get "search" => "searches#search"

  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy,]
    get "follower" => "relationships#follower"
    get "followd" => "relationships#followed"
  end

  resources :books, only: [:new, :create, :index, :show, :destroy, :edit, :update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
end