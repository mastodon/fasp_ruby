FaspDataSharing::Engine.routes.draw do
  namespace :fasp do
    resource :actor, only: [ :show ] do
      resource :inbox, only: [ :show, :create ]
      resource :outbox, only: [ :show ]
    end

    namespace :data_sharing do
      namespace :v0 do
        resources :announcements, only: [ :create ]
      end
    end
  end

  get "/.well-known/webfinger", to: "webfinger#show", as: :webfinger
end
