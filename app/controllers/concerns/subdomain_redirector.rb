module SubdomainRedirector
  extend ActiveSupport::Concern

  included do
    before_action :check_for_redirect_to_subdomain
  end

  private

  # Check if we need to perform a subdomain redirect
  def check_for_redirect_to_subdomain
    stored_location = stored_location_for(:user)

    if stored_location.present? && subdomain_url?(stored_location)
      # Clear the stored location so we don't keep redirecting
      clear_stored_location_for(:user)

      # Perform the redirect with the allow_other_host option
      redirect_to stored_location, allow_other_host: true
    end
  end

  # Check if a URL is a subdomain URL
  def subdomain_url?(url)
    uri = URI.parse(url)
    host = uri.host.to_s

    # Check if the host contains a subdomain
    host.include?(".") && ![ "www", "api" ].include?(host.split(".").first)
  end
end
