Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :dashboard, only: [ :index ]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  get "/:locale" => "home#index"
  root to: "home#index"
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :users do
      resources :profiles, only: [ :show, :edit, :update ] do
        resources :social_links, only: [ :new, :create ]
      end
    end

    resources :events, only: [ :index ] do
      resources :batches, only: [ :index ] do
        resources :tickets, only: [ :new, :create, :show ]
      end
      resources :posts, only: [ :new, :create, :show, :edit, :update ] do
        resources :likes, only: [ :create, :destroy ]
        resources :comments, only: [ :create ]
      end
      resources :announcements, only: [ :show ]
      get ":name", to: "events#show", as: "by_name"
    end

    resources :my_events, only: [ :show, :index ] do
      resources :feedbacks, only: [ :new, :create, :index ]
      resources :schedule_items do
        resources :item_feedbacks, only: [ :new, :create ]
      end
    end

    resources :my_feedbacks, only: [ :index ]
    resources :reminders, only: [ :create, :destroy ]
    resources :favorites, only: [ :index, :create, :destroy ]
  end

  namespace :api do
    namespace :v1 do
      resources :events, only: [ :show ] do
        resources :batches,  only: [ :show ]
        resources :feedbacks,  only: [ :index ]
      end
    end
  end
end
