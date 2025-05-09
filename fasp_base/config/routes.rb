FaspBase::Engine.routes.draw do
  namespace :admin do
    resource :session, only: [ :new, :create, :destroy ]

    resources :invitation_codes, only: [ :index, :create, :destroy ]

    resources :settings, only: [ :index, :update ]

    resources :users, only: [ :index, :show ] do
      resource :activation, only: [ :create, :destroy ]
    end
  end

  namespace :fasp do
    resources :capabilities, only: [] do
      resource :activation, path: "/:version/activation", only: [ :create, :destroy ]
    end
    resource :provider_info, only: :show
  end

  resource :home, only: [ :show ]

  resource :registration, only: [ :new, :create ]

  resource :session, only: [ :new, :create, :destroy ]

  resources :servers, only: [ :show ]
end
