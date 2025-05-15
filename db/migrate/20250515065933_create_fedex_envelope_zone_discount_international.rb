class CreateFedexEnvelopeZoneDiscountInternational < ActiveRecord::Migration[8.0]
  def change
    create_table :fedex_envelope_zone_discount_internationals do |t|
      t.decimal :zone_a_discount
      t.decimal :zone_b_discount
      t.decimal :zone_c_discount
      t.decimal :zone_d_discount
      t.decimal :zone_e_discount
      t.decimal :zone_f_discount
      t.decimal :zone_g_discount
      t.decimal :zone_h_discount
      t.decimal :zone_i_discount
      t.decimal :zone_j_discount
      t.decimal :zone_k_discount
      t.decimal :zone_l_discount
      t.decimal :zone_m_discount
      t.decimal :zone_n_discount
      t.decimal :zone_o_discount
      t.decimal :zone_p_discount
      t.references :fedex_international_priority_import_discount_projection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
