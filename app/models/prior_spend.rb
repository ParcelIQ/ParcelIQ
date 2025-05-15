class PriorSpend < ApplicationRecord
  belongs_to :company

  # Constants for carriers and spend types
  CARRIERS = [ "UPS", "FedEx" ].freeze
  SPEND_TYPES = [ "transportation", "surcharge", "dimensional", "per_shipment" ].freeze

  # Service types vary based on the carrier
  FEDEX_SERVICE_TYPES = [ "Priority Overnight", "2Day Express", "Ground", "Home Delivery", "Express Saver" ].freeze
  UPS_SERVICE_TYPES = [ "Next Day Air", "2nd Day Air", "Ground", "SurePost", "3 Day Select" ].freeze

  # Surcharge types
  SURCHARGE_TYPES = [ "Address Correction", "Residential Express", "Ground DAS", "Fuel Surcharge", "Direct Signature" ].freeze

  # Validations
  validates :carrier, presence: true, inclusion: { in: CARRIERS }
  validates :spend_type, presence: true, inclusion: { in: SPEND_TYPES }
  validates :service_type, presence: true
  validates :shipment_count, numericality: { greater_than_or_equal_to: 0 }
  validates :spend_amount, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_service_type

  # Validate service type based on carrier
  def validate_service_type
    valid_service_types = case carrier
    when "FedEx"
                           if spend_type == "surcharge"
                             SURCHARGE_TYPES
                           else
                             FEDEX_SERVICE_TYPES
                           end
    when "UPS"
                           if spend_type == "surcharge"
                             SURCHARGE_TYPES
                           else
                             UPS_SERVICE_TYPES
                           end
    else
                           []
    end

    unless valid_service_types.include?(service_type)
      errors.add(:service_type, "is not valid for the selected carrier and spend type")
    end
  end
end
