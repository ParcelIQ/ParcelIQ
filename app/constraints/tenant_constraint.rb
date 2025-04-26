class TenantConstraint
  def matches?(request)
    subdomain = extract_subdomain(request.host)
    return false if subdomain.blank? || subdomain == "www"

    # Check if the subdomain corresponds to a valid company
    Company.exists?(subdomain: subdomain) ||
      Company.exists?(domain: request.host)
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
