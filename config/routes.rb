Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [:show] do
    resources :availabilties, only: [:index, :edit, :create]
    get 'availabilties/edit2', to: 'availabilties#edit2'
    get 'availabilties/edit3', to: 'availabilties#edit3'
    post 'availabilties/create2', to: 'availabilties#create2'
    post 'availabilties/create3', to: 'availabilties#create3'
  end

  get 'infos', to: 'pages#infos'

  resources :users, only: [:index, :update]

  resources :users do
    member do
      patch :deactivate
      patch :reactivate
    end
  end

  get "/check_username", to: "users#check_username", as: "check_username"

  resources :settings, only: [:index, :edit, :update]

  post 'reports/table_pdf', to: 'reports#table_pdf'
  post 'reports/annual_table_pdf', to: 'reports#annual_table_pdf'

  resources :cares, only: [:index, :show, :new, :create, :edit, :update]

  patch '/users/reset_password/:id', to: 'users#reset_password', as: 'users_reset_password'

  get 'monthly_cares', to: 'cares#monthly_cares'

  get 'modify_cares', to: 'cares#modify_cares'

  delete 'cares/destroy_month', to: 'cares#destroy_month'

  resources :user_maneuvers, only: [:index, :update]
end
