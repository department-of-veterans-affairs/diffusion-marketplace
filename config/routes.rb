# frozen_string_literal: true
Rails.application.routes.draw do
  require "./lib/constraints/route_constraints"
  get ':page_group_friendly_id' => 'page#show', constraints: PageGroupHomeConstraint
  get ':page_group_friendly_id/:page_slug' => 'page#show', constraints: PageGroupConstraint
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'registrations' }
  mount Ahoy::Engine => '/ahoy', as: :dm_ahoy
  mount Commontator::Engine => '/commontator' #, as: :dm_commontator

  get '/terms_and_conditions' => 'users#terms_and_conditions'
  get '/dashboard/export', action: 'export_metrics', controller: 'admin/dashboard', as: 'export_metrics'
  post '/accept_terms', action: 'accept_terms', controller: 'users', as: 'accept_terms'

  resources :practices, except: :index do
    get '/edit/metrics', action: 'metrics', as: 'metrics'
    get '/edit/instructions', action: 'instructions', as: 'instructions'
    get '/edit/introduction', action: 'introduction', as: 'introduction'
    get '/edit/implementation', action: 'implementation', as: 'implementation'
    get '/edit/about', action: 'about', as: 'about'
    get '/edit/overview', action: 'overview', as: 'overview'
    get '/edit/collaborators', action: 'collaborators', as: 'collaborators'
    get '/edit/impact', action: 'impact', as: 'impact'
    get '/edit/resources', action: 'resources', as: 'resources'
    get '/edit/documentation', action: 'documentation', as: 'documentation'
    get '/edit/departments', action: 'departments', as: 'departments'
    get '/edit/timeline', action: 'timeline', as: 'timeline'
    get '/edit/risk_and_mitigation', action: 'risk_and_mitigation', as: 'risk_and_mitigation'
    get '/edit/contact', action: 'contact', as: 'contact'
    get '/edit/checklist', action: 'checklist', as: 'checklist'
    get '/edit/adoptions', action: 'adoptions', as: 'adoptions'
    post '/edit/create_or_update_diffusion_history/', action: 'create_or_update_diffusion_history', as: 'create_or_update_diffusion_history'
    patch '/publication_validation', action: 'publication_validation', as: 'publication_validation'
    get '/published', action: 'published', as: 'published'
    post '/favorite', action: 'favorite', as: 'favorite'
    delete '/diffusion_history/:diffusion_history_id', action: 'destroy_diffusion_history', as: 'destroy_diffusion_history'
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
  get 'pii_phi_information' => 'home#pii_phi_information'
  get '/search' => 'practices#search'
  get '/explore' => 'practices#explore'
  post '/explore' => 'practices#explore_practices'

  get '/users/:id' => 'users#show'
  get '/edit-profile' => 'users#edit_profile'
  get '/recommended-for-you' => 'users#recommended_for_you'
  post '/edit-profile' => 'users#update_profile'
  delete '/edit-profile-photo' => 'users#delete_photo'

  resource :competitions do
    get '/shark-tank', action: 'shark_tank', as: 'shark-tank'
    get '/go-fish', action: 'go_fish', as: 'go-fish'
  end

  get '/nominate-a-practice', controller: 'nominate_practices', action: 'index', as: 'nominate_a_practice'
  get '/diffusion-map', controller: 'home', action: 'diffusion_map', as: 'diffusion_map'

  namespace :system do
    get 'status' => 'status#index', as: 'status'
  end

  # Custom route for reporting a comment
  # get '/practices/:practice_id/comments/:comment_id/report', action: 'report_comment', controller: 'commontator/comments', as: 'report_comment'
end
