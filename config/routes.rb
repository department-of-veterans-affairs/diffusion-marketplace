Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  resources :domains
  resources :departments
  resources :practice_managements
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :developing_facility_types
  resources :va_employees
  resources :practices do
    get '/next-steps', action: 'next_steps', as: 'next_steps'
    get '/committed', action: 'committed', as: 'committed'
    post '/commit', action: 'commit', as: 'commit'
  end
  resources :badges
  resources :job_positions
  resources :job_position_categories
  resources :categories
  resources :clinical_locations
  resources :clinical_conditions
  resources :ancillary_services
  resources :va_secretary_priorities
  resources :practice_partners, path: :partners
  resources :users, except: [:show, :create, :new, :edit] do
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
end
