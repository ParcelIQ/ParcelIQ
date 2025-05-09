class UpsInvoiceEntry < ApplicationRecord
  belongs_to :shipping_invoice

  # Validations
  validates :invoice_date, presence: true
  validates :invoice_number, presence: true
  validates :tracking_number, presence: true

  # Scopes
  scope :by_shipping_invoice, ->(shipping_invoice_id) { where(shipping_invoice_id: shipping_invoice_id) }
  scope :ordered, -> { order(invoice_date: :desc) }
  scope :apply_date_filters, ->(start_date, end_date) do
    scope = all
    scope = scope.where("invoice_date >= ?", start_date) if start_date.present?
    scope = scope.where("invoice_date <= ?", end_date) if end_date.present?
    scope
  end
end
