class RemovePakboxMinChargeFromFedexPakBoxMinimumCharges < ActiveRecord::Migration[7.0]
  def change
    remove_column :fedex_pak_box_minimum_charges, :pakbox_min_charge, :decimal
  end
end
