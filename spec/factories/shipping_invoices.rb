FactoryBot.define do
  factory :shipping_invoice do
    name { "MyString" }
    company { nil }
    carrier { "MyString" }
    invoice_uploaded_date { "2025-04-27" }
  end
end
