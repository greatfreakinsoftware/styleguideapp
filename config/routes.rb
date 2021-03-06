require 'sidekiq/web'
Rails.application.routes.draw do

  authenticated :user, -> user { user.email == 'nphaskins@gmail.com' } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, skip: :registrations, path: '', path_names: { sign_in: 'login', sign_out: 'logout'}

  post '/webhooks/process' => 'stripe#process_webhook'

  # Super Tenant
  constraints(:host => (Rails.env.production? ? 'styleguides.app' : 'lvh.me' ) ) do

    get 'register'      => 'register#index'
    post '/register'    => 'register#create'
    namespace :account do
      get '/'               => '/accounts#index'
      get '/collaborators' => 'collaborators#index'
      resources :invites
      resources :subscriptions do

        member do
          post 'update-card'    => 'subscriptions#update_card',   as: :update_card
          post 'cancel'         => 'subscriptions#cancel',        as: :cancel
          post 'reactivate'     => 'subscriptions#reactivate',    as: :reactivate
        end

      end
      resources :payments
      resources :brands do
        member do
          post '/connect-site'       => 'connect_site#connect',        as: :connect_site
          post '/connect-site-style' => 'connect_site#connect_style',  as: :connect_site_style
        end
      end
    end
  end

  # Tenant
  constraints(SubDomainConstraint) do
    get '/'   => 'brands#show', as: :brand_root

    resources :logos
    resources :colors
    resources :color_categories
    resources :fonts
    resources :spacers
    resources :components

    namespace :settings do
      get '/'         => '/settings#index'
      post '/update'  => '/settings#update', as: :update
    end

    namespace :invites do
      get '/'       => '/invites#index'
      post '/claim' => '/invites#claim'
    end
  end

  root 'home#index'

end
