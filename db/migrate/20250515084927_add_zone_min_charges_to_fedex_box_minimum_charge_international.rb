class AddZoneMinChargesToFedexBoxMinimumChargeInternational < ActiveRecord::Migration[8.0]
  def change
    add_column :fedex_box_minimum_charge_internationals, :zone_a_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_b_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_c_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_d_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_e_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_f_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_g_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_h_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_i_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_j_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_k_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_l_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_m_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_n_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_o_min_charge, :decimal
    add_column :fedex_box_minimum_charge_internationals, :zone_p_min_charge, :decimal
  end
end
