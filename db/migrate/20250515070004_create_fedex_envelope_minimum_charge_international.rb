class CreateFedexEnvelopeMinimumChargeInternational < ActiveRecord::Migration[8.0]
  def change
    create_table :fedex_envelope_minimum_charge_internationals do |t|
      t.decimal :envelope_min_charge
      t.decimal :zone_a_min_charge
      t.decimal :zone_b_min_charge
      t.decimal :zone_c_min_charge
      t.decimal :zone_d_min_charge
      t.decimal :zone_e_min_charge
      t.decimal :zone_f_min_charge
      t.decimal :zone_g_min_charge
      t.decimal :zone_h_min_charge
      t.decimal :zone_i_min_charge
      t.decimal :zone_j_min_charge
      t.decimal :zone_k_min_charge
      t.decimal :zone_l_min_charge
      t.decimal :zone_m_min_charge
      t.decimal :zone_n_min_charge
      t.decimal :zone_o_min_charge
      t.decimal :zone_p_min_charge
      t.decimal :zone_a_percentage_reduction
      t.decimal :zone_b_percentage_reduction
      t.decimal :zone_c_percentage_reduction
      t.decimal :zone_d_percentage_reduction
      t.decimal :zone_e_percentage_reduction
      t.decimal :zone_f_percentage_reduction
      t.decimal :zone_g_percentage_reduction
      t.decimal :zone_h_percentage_reduction
      t.decimal :zone_i_percentage_reduction
      t.decimal :zone_j_percentage_reduction
      t.decimal :zone_k_percentage_reduction
      t.decimal :zone_l_percentage_reduction
      t.decimal :zone_m_percentage_reduction
      t.decimal :zone_n_percentage_reduction
      t.decimal :zone_o_percentage_reduction
      t.decimal :zone_p_percentage_reduction
      t.decimal :zone_a_dollar_reduction
      t.decimal :zone_b_dollar_reduction
      t.decimal :zone_c_dollar_reduction
      t.decimal :zone_d_dollar_reduction
      t.decimal :zone_e_dollar_reduction
      t.decimal :zone_f_dollar_reduction
      t.decimal :zone_g_dollar_reduction
      t.decimal :zone_h_dollar_reduction
      t.decimal :zone_i_dollar_reduction
      t.decimal :zone_j_dollar_reduction
      t.decimal :zone_k_dollar_reduction
      t.decimal :zone_l_dollar_reduction
      t.decimal :zone_m_dollar_reduction
      t.decimal :zone_n_dollar_reduction
      t.decimal :zone_o_dollar_reduction
      t.decimal :zone_p_dollar_reduction
      t.references :fedex_international_priority_import_discount_projection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
