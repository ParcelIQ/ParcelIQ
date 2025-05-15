class FedexEnvelopeZoneDiscount < ApplicationRecord
  belongs_to :fedex_discount_projection

  ZONE_FIELDS = %i[
    zone_2_discount zone_3_discount zone_4_discount zone_5_discount
    zone_6_discount zone_7_discount zone_8_discount zone_9_10_discount
    zone_13_16_discount
  ]

  ZONE_FIELDS.each do |field|
    validates field, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }
  end
end
