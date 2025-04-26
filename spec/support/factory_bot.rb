require 'factory_bot'

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name { "Test User" }
    password { "password123" }
    password_confirmation { "password123" }
    role { "admin" }  # Valid roles are 'admin' and 'customer'

    factory :admin_user do
      role { "admin" }
    end

    factory :customer_user do
      role { "customer" }
      association :company
    end
  end

  factory :company do
    sequence(:name) { |n| "Company #{n}" }
    sequence(:subdomain) { |n| "company#{n}" }
    sequence(:email) { |n| "contact#{n}@example.com" }
    active { true }
    street_address { "123 Main St" }
    city { "New York" }
    state { "NY" }
    zip { "10001" }
    country { "USA" }
    phone_number { "555-123-4567" }
    website { "https://example.com" }
    time_zone { "UTC" }
  end
end
