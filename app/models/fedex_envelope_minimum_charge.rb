class FedexEnvelopeMinimumCharge < ApplicationRecord
  belongs_to :fedex_discount_projection

  validates :envelope_min_charge, numericality: { greater_than: 0, allow_nil: true }

  PERCENTAGE_FIELDS = %i[
    zone_2_percentage_reduction zone_3_percentage_reduction zone_4_percentage_reduction
    zone_5_percentage_reduction zone_6_percentage_reduction zone_7_percentage_reduction
    zone_8_percentage_reduction zone_9_10_percentage_reduction zone_13_16_percentage_reduction
  ]

  DOLLAR_FIELDS = %i[
    zone_2_dollar_reduction zone_3_dollar_reduction zone_4_dollar_reduction
    zone_5_dollar_reduction zone_6_dollar_reduction zone_7_dollar_reduction
    zone_8_dollar_reduction zone_9_10_dollar_reduction zone_13_16_dollar_reduction
  ]

  PERCENTAGE_FIELDS.each do |field|
    validates field, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }
  end

  DOLLAR_FIELDS.each do |field|
    validates field, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  end
end
