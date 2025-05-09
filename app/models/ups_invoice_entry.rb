class UpsInvoiceEntry < ApplicationRecord
  belongs_to :shipping_invoice

  # Validations
  validates :invoice_date, presence: true
  validates :invoice_number, presence: true
  validates :tracking_number, presence: true

  # Scopes
  scope :by_shipping_invoice, ->(shipping_invoice_id) { where(shipping_invoice_id: shipping_invoice_id) }
  scope :ordered, -> { order(invoice_date: :desc) }
end
