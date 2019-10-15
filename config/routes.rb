# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'registrations' }
  mount Ahoy::Engine => '/ahoy', as: :dm_ahoy

  resources :practices do
    get '/planning-checklist', action: 'planning_checklist', as: 'planning_checklist'
    get '/committed', action: 'committed', as: 'committed'
    post '/commit', action: 'commit', as: 'commit'
    post '/favorite', action: 'favorite', as: 'favorite'
    member do
      post :highlight
      post :un_highlight
      post :feature
      post :un_feature
    end
  end
  resources :practice_partners, path: :partners
  resources :users, except: %i[show create new edit] do
    patch :re_enable
  end
  resources :admin, only: [] do
    collection do
      post :create_user
    end
  end

  root 'home#index'
  get '/practices' => 'practices#index'
  get '/partners' => 'practice_partners#index'
  # Adding this for the View Toolkit button on practice page. Though we don't have any uploaded yet so I'm not using it.
  get 'practices/view_toolkit' => 'practices#view_toolkit'
  # Ditto for "Planning Checklist"
  get 'practices/planning_checklist' => 'practices#planning_checklist'
  get '/search' => 'practices#search'

  get '/users/:id' => 'users#show'
  get '/edit-profile' => 'users#edit_profile'
  post '/edit-profile' => 'users#update_profile'
  delete '/edit-profile-photo' => 'users#delete_photo'
end
