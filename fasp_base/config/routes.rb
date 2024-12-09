FaspBase::Engine.routes.draw do
  namespace :fasp do
    resource :provider_info, only: :show
  end

  resource :home, only: [ :show ]

  resource :registration, only: [ :new, :create ]

  resource :session, only: [ :new, :create, :destroy ]

  resources :servers, only: [ :show ]
end
