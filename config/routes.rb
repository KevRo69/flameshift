Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [:show] do
    resources :availabilties, only: [:index, :edit, :create]
    get 'availabilties/edit2', to: 'availabilties#edit2'
    get 'availabilties/edit3', to: 'availabilties#edit3'
  end


  resources :users, only: [:index, :update]

  resources :cares, only: [:index, :show, :new, :create, :edit, :update]

  get 'monthly_cares', to: 'cares#monthly_cares'

  get 'modify_cares', to: 'cares#modify_cares'

  delete 'cares/destroy_month', to: 'cares#destroy_month'
end
