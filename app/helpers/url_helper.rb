module UrlHelper
  # Generate a URL for the customer dashboard with a specified subdomain
  def generate_customer_dashboard_url(options = {})
    subdomain = options.delete(:subdomain) || ""
    host = options.delete(:host) || ""

    protocol = Rails.env.development? ? "http://" : "https://"
    "#{protocol}#{subdomain}.#{host}/customer/dashboard"
  end
end
