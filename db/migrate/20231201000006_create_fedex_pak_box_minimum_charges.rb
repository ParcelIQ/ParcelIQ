class CreateFedexPakBoxMinimumCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :fedex_pak_box_minimum_charges do |t|
      t.references :fedex_discount_projection, null: false, foreign_key: true, index: { name: 'idx_fedex_pak_box_min_charges_on_proj_id' }
      t.decimal :pakbox_min_charge, precision: 10, scale: 2, default: 42.31
      t.decimal :zone_2_percentage_reduction, precision: 5, scale: 2
      t.decimal :zone_3_percentage_reduction, precision: 5, scale: 2
      t.decimal :zone_4_percentage_reduction, precision: 5, scale: 2
      t.decimal :zone_5_percentage_reduction, precision: 5, scale: 2
      t.decimal :zone_6_percentage_reduction, precision: 5, scale: 2
      t.decimal :zone_7_percentage_reduction, precision: 5, scale: 2
      t.decimal :zone_8_percentage_reduction, precision: 5, scale: 2
      t.decimal :zone_9_10_percentage_reduction, precision: 5, scale: 2
      t.decimal :zone_13_16_percentage_reduction, precision: 5, scale: 2
      t.decimal :zone_2_dollar_reduction, precision: 10, scale: 2
      t.decimal :zone_3_dollar_reduction, precision: 10, scale: 2
      t.decimal :zone_4_dollar_reduction, precision: 10, scale: 2
      t.decimal :zone_5_dollar_reduction, precision: 10, scale: 2
      t.decimal :zone_6_dollar_reduction, precision: 10, scale: 2
      t.decimal :zone_7_dollar_reduction, precision: 10, scale: 2
      t.decimal :zone_8_dollar_reduction, precision: 10, scale: 2
      t.decimal :zone_9_10_dollar_reduction, precision: 10, scale: 2
      t.decimal :zone_13_16_dollar_reduction, precision: 10, scale: 2
      t.timestamps
    end
  end
end
