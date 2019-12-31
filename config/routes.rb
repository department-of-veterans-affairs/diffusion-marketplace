# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'registrations' }
  mount Ahoy::Engine => '/ahoy', as: :dm_ahoy
  mount Commontator::Engine => '/commontator' #, as: :dm_commontator

  get '/terms_and_conditions' => 'users#terms_and_conditions'
  post '/accept_terms', action: 'accept_terms', controller: 'users', as: 'accept_terms'

  resources :practices, except: :index do
    get '/planning-checklist', action: 'planning_checklist', as: 'planning_checklist'
    get '/committed', action: 'committed', as: 'committed'
    get '/edit/instructions', action: 'instructions', as: 'instructions'
    get '/edit/overview', action: 'overview', as: 'overview'
    get '/edit/collaborators', action: 'collaborators', as: 'collaborators'
    get '/edit/impact', action: 'impact', as: 'impact'
    get '/edit/resources', action: 'resources', as: 'resources'
    get '/edit/documentation', action: 'documentation', as: 'documentation'
    get '/edit/complexity', action: 'complexity', as: 'complexity'
    get '/edit/timeline', action: 'timeline', as: 'timeline'
    get '/edit/risk_and_mitigation', action: 'risk_and_mitigation', as: 'risk_and_mitigation'
    get '/edit/contact', action: 'contact', as: 'contact'
    get '/edit/checklist', action: 'checklist', as: 'checklist'
    get '/edit/origin', action: 'origin', as: 'origin'
    post '/publication_validation', action: 'publication_validation', as: 'publication_validation'
    get '/published', action: 'published', as: 'published'
    post '/commit', action: 'commit', as: 'commit'
    post '/favorite', action: 'favorite', as: 'favorite'
    member do
      post :highlight
      post :un_highlight
      post :feature
      post :un_feature
    end
    resources :comments do
      member do
          put 'like' => 'commontator/comments#upvote'
          get 'report', to: 'commontator/comments#report_comment', as: 'report'
      end
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
  # Custom route for reporting a comment
  # get '/practices/:practice_id/comments/:comment_id/report', action: 'report_comment', controller: 'commontator/comments', as: 'report_comment'
end
