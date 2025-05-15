require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Require devise explicitly
require "devise"

# Require our custom middleware
require_relative "../app/middleware/tenant_middleware"
require_relative "../app/constraints/tenant_constraint"

module ParcelIQ
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks templates generators])

    # Exclude generator templates from Zeitwerk autoloading
    config.to_prepare do
      Rails.autoloaders.main.ignore(Rails.root.join("lib/generators/*/templates"))
    end

    # Use autoload paths for our middleware
    config.autoload_paths += %W[#{config.root}/app/middleware #{config.root}/app/constraints]

    # Add tenant middleware to handle subdomain-based multitenancy
    config.middleware.use TenantMiddleware

    # Configure hosts to allow all subdomains of localhost in development
    if Rails.env.development?
      config.hosts << /.*\.localhost/
    end

    # Set DEFAULT_HOST environment variable to handle flexible domains
    ENV["DEFAULT_HOST"] ||= Rails.env.production? ? "myparceliq.com" : "localhost:3000"

    # Allow redirects to subdomains of the main domain
    config.action_controller.raise_on_open_redirects = false

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Explicitly add app/services to the autoload paths
    config.autoload_paths += %W[#{config.root}/app/services]
    config.eager_load_paths += %W[#{config.root}/app/services]
  end
end
