class CreateFedexEnvelopeZoneDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :fedex_envelope_zone_discounts do |t|
      t.references :fedex_discount_projection, null: false, foreign_key: true, index: { name: 'idx_fedex_env_zone_disc_on_proj_id' }
      t.decimal :zone_2_discount, precision: 5, scale: 2
      t.decimal :zone_3_discount, precision: 5, scale: 2
      t.decimal :zone_4_discount, precision: 5, scale: 2
      t.decimal :zone_5_discount, precision: 5, scale: 2
      t.decimal :zone_6_discount, precision: 5, scale: 2
      t.decimal :zone_7_discount, precision: 5, scale: 2
      t.decimal :zone_8_discount, precision: 5, scale: 2
      t.decimal :zone_9_10_discount, precision: 5, scale: 2
      t.decimal :zone_13_16_discount, precision: 5, scale: 2
      t.timestamps
    end
  end
end
