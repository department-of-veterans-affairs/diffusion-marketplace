Rails.application.routes.draw do
  resources :departments
  resources :practice_managements
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :developing_facility_types
  resources :va_employees
  resources :practices
  resources :badges
  resources :job_positions
  resources :job_position_categories
  resources :impacts
  resources :impact_categories
  resources :clinical_locations
  resources :clinical_conditions
  resources :ancillary_services
  resources :va_secretary_priorities
  resources :strategic_sponsors
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
  # Adding this for the View Toolkit button on practice page. Though we don't have any uploaded yet so I'm not using it.
  get 'practices/view_toolkit' => 'practices#view_toolkit'
  # Ditto for "Planning Checklist"
  get 'practices/planning_checklist' => 'practices#planning_checklist'
end
