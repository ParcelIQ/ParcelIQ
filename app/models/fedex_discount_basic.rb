class FedexDiscountBasic < ApplicationRecord
  belongs_to :fedex_priority_overnight_discount_projection, foreign_key: "fedex_priority_overnight_discount_projection_id", optional: true

  validates :dim_divisor, numericality: { greater_than: 0, allow_nil: true }
  validates :envelope_earned_discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }
  validates :pakbox_earned_discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }
end
