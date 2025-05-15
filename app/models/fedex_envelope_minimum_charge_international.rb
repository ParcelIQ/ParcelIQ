class FedexEnvelopeMinimumChargeInternational < ApplicationRecord
  belongs_to :fedex_international_priority_import_discount_projection, foreign_key: "fedex_international_priority_import_discount_projection_id"

  validates :envelope_min_charge, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  ZONE_FIELDS = {
    min_charge: %i[
      zone_a_min_charge zone_b_min_charge zone_c_min_charge zone_d_min_charge
      zone_e_min_charge zone_f_min_charge zone_g_min_charge zone_h_min_charge
      zone_i_min_charge zone_j_min_charge zone_k_min_charge zone_l_min_charge
      zone_m_min_charge zone_n_min_charge zone_o_min_charge zone_p_min_charge
    ],
    percentage_reduction: %i[
      zone_a_percentage_reduction zone_b_percentage_reduction zone_c_percentage_reduction zone_d_percentage_reduction
      zone_e_percentage_reduction zone_f_percentage_reduction zone_g_percentage_reduction zone_h_percentage_reduction
      zone_i_percentage_reduction zone_j_percentage_reduction zone_k_percentage_reduction zone_l_percentage_reduction
      zone_m_percentage_reduction zone_n_percentage_reduction zone_o_percentage_reduction zone_p_percentage_reduction
    ],
    dollar_reduction: %i[
      zone_a_dollar_reduction zone_b_dollar_reduction zone_c_dollar_reduction zone_d_dollar_reduction
      zone_e_dollar_reduction zone_f_dollar_reduction zone_g_dollar_reduction zone_h_dollar_reduction
      zone_i_dollar_reduction zone_j_dollar_reduction zone_k_dollar_reduction zone_l_dollar_reduction
      zone_m_dollar_reduction zone_n_dollar_reduction zone_o_dollar_reduction zone_p_dollar_reduction
    ]
  }

  ZONE_FIELDS[:min_charge].each do |field|
    validates field, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  end

  ZONE_FIELDS[:percentage_reduction].each do |field|
    validates field, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }
  end

  ZONE_FIELDS[:dollar_reduction].each do |field|
    validates field, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  end
end
