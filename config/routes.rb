Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Public routes (marketing site, sign up, etc.)
  constraints lambda { |request| request.subdomain.blank? || request.subdomain == "www" } do
    # Define your public routes here
    root to: "pages#home", as: :public_root

    # Company signup and account creation
    resources :companies, only: [ :new, :create ], path: "signup"
  end

  # Tenant-specific routes
  constraints TenantConstraint.new do
    # Define your tenant-specific routes here
    root to: "dashboard#index", as: :tenant_root

    # User management within a tenant
    resources :users

    # Company settings for the current tenant
    resource :company_settings, only: [ :show, :edit, :update ]
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
