class FedexBoxZoneDiscountInternational < ApplicationRecord
  belongs_to :fedex_international_priority_import_discount_projection, foreign_key: "fedex_international_priority_import_discount_projection_id", optional: true

  validates :low_weight, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :max_weight, numericality: { greater_than: 0, allow_nil: true }
  validate :max_weight_greater_than_low_weight

  ZONE_FIELDS = %i[
    zone_a_discount zone_b_discount zone_c_discount zone_d_discount
    zone_e_discount zone_f_discount zone_g_discount zone_h_discount
    zone_i_discount zone_j_discount zone_k_discount zone_l_discount
    zone_m_discount zone_n_discount zone_o_discount zone_p_discount
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
