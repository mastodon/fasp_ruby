Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :fasp do
    namespace :debug do
      namespace :v0 do
        namespace :callback do
          resources :logs, only: [ :create ]
        end
      end
    end
  end

  resources :accounts, only: [ :index, :show, :destroy ]

  resources :contents, only: [ :index, :show, :destroy ]

  resources :logs, only: [ :index, :destroy ]

  resources :subscriptions, only: [ :index, :create, :destroy ]

  mount FaspBase::Engine, at: "/"
  mount FaspDataSharing::Engine, at: "/"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "fasp_base/homes#show"
end
