FactoryBot.define do
  factory :prior_spend do
    company { nil }
    carrier { "MyString" }
    spend_type { "MyString" }
    service_type { "MyString" }
    shipment_count { 1 }
    spend_amount { "9.99" }
  end
end
