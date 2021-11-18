# frozen_string_literal: true
Rails.application.routes.draw do
  require "./lib/constraints/route_constraints"
  get ':page_group_friendly_id' => 'page#show', constraints: PageGroupHomeConstraint
  get ':page_group_friendly_id/:page_slug' => 'page#show', constraints: PageGroupConstraint
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'registrations' }
  devise_scope :user do
    get   "/check_session_timeout"    => "session_timeout#check_session_timeout"
    get   "/session_timeout"          => "session_timeout#render_timeout"
  end
  mount Ahoy::Engine => '/ahoy', as: :dm_ahoy
  mount Commontator::Engine => '/commontator' #, as: :dm_commontator

  get '/dashboard/export', action: 'export_metrics', controller: 'admin/dashboard', as: 'export_metrics'
  get '/session_time_remaining', action: 'session_time_remaining', controller: 'practices', as: 'session_time_remaining'
  patch '/update_category_usage', action: 'update_category_usage', controller: 'categories', as: 'update_category_usage'
  patch '/extend_editor_session_time', action: 'extend_editor_session_time', controller: 'practices', as: 'extend_editor_session_time'
  patch '/close_edit_session', action: 'close_edit_session', controller: 'practices', as: 'close_edit_session'
  post '/accept_terms', action: 'accept_terms', controller: 'users', as: 'accept_terms'

  resources :practices, path: 'innovations', except: :index do
    get '/edit/metrics', action: 'metrics', as: 'metrics'
    get '/edit/instructions', action: 'instructions', as: 'instructions'
    get '/edit/editors', action: 'editors', as: 'editors'
    get '/edit/introduction', action: 'introduction', as: 'introduction'
    get '/edit/implementation', action: 'implementation', as: 'implementation'
    get '/edit/about', action: 'about', as: 'about'
    get '/edit/overview', action: 'overview', as: 'overview'
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

  # old practice routes redirects
  get '/practices/:id', to: redirect('/innovations/%{id}', status: 302)
  get '/practices/:id/edit/metrics', to: redirect('/innovations/%{id}/edit/metrics', status: 302)
  get '/practices/:id/edit/instructions', to: redirect('/innovations/%{id}/edit/instructions', status: 302)
  get '/practices/:id/edit/editors', to: redirect('/innovations/%{id}/edit/editors', status: 302)
  get '/practices/:id/edit/introduction', to: redirect('/innovations/%{id}/edit/introduction', status: 302)
  get '/practices/:id/edit/adoptions', to: redirect('/innovations/%{id}/edit/adoptions', status: 302)
  get '/practices/:id/edit/overview', to: redirect('/innovations/%{id}/edit/overview', status: 302)
  get '/practices/:id/edit/implementation', to: redirect('/innovations/%{id}/edit/implementation', status: 302)
  get '/practices/:id/edit/contact', to: redirect('/innovations/%{id}/edit/contact', status: 302)
  get '/practices/:id/edit/about', to: redirect('/innovations/%{id}/edit/about', status: 302)

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

  # redirect users to /nominate-an-innovation if they try to visit the old /nominate-a-practice URL
  get '/nominate-a-practice', to: redirect('/nominate-an-innovation', status: 302)
  get '/nominate-an-innovation', controller: 'nominate_practices', action: 'index', as: 'nominate_an_innovation'
  post '/nominate-an-innovation', controller: 'nominate_practices', action: 'email'
  get '/diffusion-map', controller: 'home', action: 'diffusion_map', as: 'diffusion_map'

  namespace :system do
    get 'status' => 'status#index', as: 'status'
  end

  # set the param to the visn number instead of the visn id
  resources :visns, param: :number
  get '/visns/:number/load-facilities-rows', controller: 'visns', action: 'load_facilities_show_rows'
  resources :va_facilities, path: :facilities do
    collection do
      get '/load-facilities-rows', controller: 'va_facilities', action: 'load_facilities_index_rows'
    end
  end
  get '/facilities/:id/created-practices', controller: 'va_facilities', action: 'created_practices'
  get '/facilities/:id/update_practices_adopted_at_facility', action: 'update_practices_adopted_at_facility', controller: 'va_facilities'
  get '/about', controller: 'about', action: 'index', as: 'about'
  post '/about', controller: 'about', action: 'email'

  match '/404', to: 'errors#page_not_found_404', via: :all

  # Custom route for reporting a comment
  # get '/practices/:practice_id/comments/:comment_id/report', action: 'report_comment', controller: 'commontator/comments', as: 'report_comment'
end
