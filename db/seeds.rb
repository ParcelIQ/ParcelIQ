# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create demo companies
companies = [
  {
    name: "Acme Corp",
    subdomain: "acme",
    domain: "acmecorp.example.com",
    time_zone: "Eastern Time (US & Canada)",
    street_address: "123 Main St",
    city: "New York",
    state: "NY",
    zip: "10001",
    country: "USA",
    phone_number: "212-555-1234",
    email: "info@acmecorp.example.com",
    website: "https://acmecorp.example.com",
    tax_id: "12-3456789",
    plan: "enterprise",
    active: true,
    settings: { theme: "light", notifications_enabled: true }.to_json,
    metadata: { industry: "Technology", size: "Enterprise" }.to_json
  },
  {
    name: "Globex Inc",
    subdomain: "globex",
    domain: "globexinc.example.com",
    time_zone: "Pacific Time (US & Canada)",
    street_address: "456 Market St",
    city: "San Francisco",
    state: "CA",
    zip: "94105",
    country: "USA",
    phone_number: "415-555-5678",
    email: "info@globexinc.example.com",
    website: "https://globexinc.example.com",
    tax_id: "98-7654321",
    plan: "pro",
    active: true,
    settings: { theme: "dark", notifications_enabled: true }.to_json,
    metadata: { industry: "Finance", size: "Medium" }.to_json
  }
]

companies.each do |company_data|
  company = Company.find_or_initialize_by(subdomain: company_data[:subdomain])
  company.update!(company_data)

  puts "Created company: #{company.name}"

  # Create users for each company
  ActsAsTenant.with_tenant(company) do
    3.times do |i|
      user = User.find_or_initialize_by(email: "user#{i+1}@#{company.subdomain}.example.com")
      user.update!(
        name: "User #{i+1}",
        email: "user#{i+1}@#{company.subdomain}.example.com"
      )
      puts "  Created user: #{user.name} (#{user.email})"
    end
  end
end

puts "Seed data created successfully!"
