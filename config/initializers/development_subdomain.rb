# Special handling for localhost subdomains in development
if Rails.env.development?
  # Override the extract_subdomain method for local development
  TenantMiddleware.class_eval do
    def extract_subdomain(host)
      return nil if host.blank?

      # Handle local development with patterns like 'acme.localhost:3000'
      if host.include?("localhost")
        parts = host.split(".")
        return parts.first if parts.size > 1 && parts.first != "www"
      end

      # Original implementation for non-localhost domains
      parts = host.split(".")
      return nil if parts.size <= 2 # No subdomain in example.com

      # For hosts like 'company.example.com', return 'company'
      parts.first if parts.size > 2
    end
  end

  # Same override for TenantConstraint
  TenantConstraint.class_eval do
    def extract_subdomain(host)
      return nil if host.blank?

      # Handle local development with patterns like 'acme.localhost:3000'
      if host.include?("localhost")
        parts = host.split(".")
        return parts.first if parts.size > 1 && parts.first != "www"
      end

      # Original implementation for non-localhost domains
      parts = host.split(".")
      return nil if parts.size <= 2 # No subdomain in example.com

      # For hosts like 'company.example.com', return 'company'
      parts.first if parts.size > 2
    end
  end
end
