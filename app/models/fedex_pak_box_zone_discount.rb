class FedexPakBoxZoneDiscount < ApplicationRecord
  belongs_to :fedex_priority_overnight_discount_projection, foreign_key: "fedex_priority_overnight_discount_projection_id"

  validates :low_weight, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :max_weight, numericality: { greater_than: 0, allow_nil: true }
  validate :max_weight_greater_than_low_weight

  ZONE_FIELDS = %i[
    zone_2_discount zone_3_discount zone_4_discount zone_5_discount
    zone_6_discount zone_7_discount zone_8_discount zone_9_10_discount
    zone_13_16_discount
  ]

  ZONE_FIELDS.each do |field|
    validates field, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }
  end

  private

  def max_weight_greater_than_low_weight
    return if low_weight.blank? || max_weight.blank?

    if max_weight <= low_weight
      errors.add(:max_weight, "must be greater than low weight")
    end
  end
end
