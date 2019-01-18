Rails.application.routes.draw do
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
  root 'home#index'
  get '/practices' => 'practices#index'
  # Adding this for the Download Toolkit button on practice page. Though we don't have any uploaded yet so I'm not using it.
  get 'practices/download_toolkit' => 'practices#download_toolkit'
end
