class AddZoneMinChargesToFedexPakBoxMinimumCharges < ActiveRecord::Migration[7.0]
  def change
    add_column :fedex_pak_box_minimum_charges, :zone_2_min_charge, :decimal, precision: 10, scale: 2
    add_column :fedex_pak_box_minimum_charges, :zone_3_min_charge, :decimal, precision: 10, scale: 2
    add_column :fedex_pak_box_minimum_charges, :zone_4_min_charge, :decimal, precision: 10, scale: 2
    add_column :fedex_pak_box_minimum_charges, :zone_5_min_charge, :decimal, precision: 10, scale: 2
    add_column :fedex_pak_box_minimum_charges, :zone_6_min_charge, :decimal, precision: 10, scale: 2
    add_column :fedex_pak_box_minimum_charges, :zone_7_min_charge, :decimal, precision: 10, scale: 2
    add_column :fedex_pak_box_minimum_charges, :zone_8_min_charge, :decimal, precision: 10, scale: 2
    add_column :fedex_pak_box_minimum_charges, :zone_9_10_min_charge, :decimal, precision: 10, scale: 2
    add_column :fedex_pak_box_minimum_charges, :zone_13_16_min_charge, :decimal, precision: 10, scale: 2
  end
end
