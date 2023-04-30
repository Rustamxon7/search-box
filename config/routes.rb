Rails.application.routes.draw do
  resources :arguments

  resources :articles
  devise_for :users

  root "articles#index"

  post "articles/suggestions", to: "articles#suggestions", as: :suggestions
end
