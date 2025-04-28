class ShippingInvoice < ApplicationRecord
  belongs_to :company
  has_one_attached :csv_file

  # Constants for carrier options
  CARRIERS = [ "FedEx", "UPS" ].freeze

  # Validations
  validates :name, presence: true
  validates :carrier, presence: true, inclusion: { in: CARRIERS }
  validates :invoice_uploaded_date, presence: true
  validates :csv_file, presence: true
  validate :correct_csv_mime_type

  # Scopes
  scope :by_company, ->(company_id) { where(company_id: company_id) }
  scope :ordered, -> { order(invoice_uploaded_date: :desc) }

  private

  def correct_csv_mime_type
    if csv_file.attached? && !csv_file.content_type.in?([ "text/csv", "application/csv", "application/vnd.ms-excel" ])
      errors.add(:csv_file, "must be a CSV file")
    end
  end
end
