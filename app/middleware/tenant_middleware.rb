class TenantMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    # Extract subdomain from host
    host = request.host.to_s
    subdomain = extract_subdomain(host)

    if subdomain.present? && subdomain != "www"
      company = Company.find_by(subdomain: subdomain)

      # Alternatively use domain if subdomain is not found
      company ||= Company.find_by(domain: host)

      if company
        ActsAsTenant.current_tenant = company
      else
        # Handle invalid tenant (redirect to marketing site or error page)
        return [ 302, { "Location" => "http://#{ENV['DEFAULT_HOST'] || 'localhost:3000'}" }, [] ]
      end
    end

    @app.call(env)
  ensure
    ActsAsTenant.current_tenant = nil
  end

  private

  def extract_subdomain(host)
    return nil if host.blank?

    parts = host.split(".")
    return nil if parts.size <= 2 # No subdomain in localhost or example.com

    # For hosts like 'company.example.com', return 'company'
    parts.first if parts.size > 2
  end
end
