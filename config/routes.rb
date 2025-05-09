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

    # Public login page - customize Devise routes to only allow login, not registration
    devise_for :users, skip: [ :registrations ], path: "",
                       path_names: { sign_in: "login" }
  end

  # Tenant-specific routes
  constraints TenantConstraint.new do
    # Define your tenant-specific routes here
    root to: "dashboard#index", as: :tenant_root

    # Tenant-specific authentication routes with full functionality
    devise_for :users, skip: [ :registrations ],
                       path: "auth",
                       path_names: { sign_in: "login", sign_out: "logout" },
                       as: "tenant"

    # Add a custom route for user management (registration) by admins
    resources :users

    # Company settings for the current tenant
    resource :company_settings, only: [ :show, :edit, :update ]

    # Customer-specific routes
    namespace :customer do
      get "dashboard", to: "dashboard#index", as: :dashboard
      get "reports", to: "reports#index", as: :reports
      resources :shipping_invoices
    end
  end

  # Root admin routes (available on all domains)
  namespace :admin do
    get "dashboard", to: "dashboard#index", as: :dashboard
    resources :companies do
      member do
        put :toggle_active
      end
    end
    resources :users do
      member do
        post :resend_invitation
      end
    end
    resources :shipping_invoices do
      member do
        post :reprocess
      end
    end
  end

  # Add a test route for the TestController
  namespace :admin do
    get "test", to: "test#index"
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # Define fallback root for when no other root routes match (for testing)
  root to: proc { [ 200, {}, [ "Root Path" ] ] }, as: :root
end
