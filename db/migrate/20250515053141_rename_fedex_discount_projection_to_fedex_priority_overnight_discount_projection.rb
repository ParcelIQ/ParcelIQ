class RenameFedexDiscountProjectionToFedexPriorityOvernightDiscountProjection < ActiveRecord::Migration[8.0]
  def up
    # Rename the main table
    rename_table :fedex_discount_projections, :fedex_priority_overnight_discount_projections

    # Update foreign keys in related tables
    rename_column :fedex_discount_basics, :fedex_discount_projection_id, :fedex_priority_overnight_discount_projection_id
    rename_column :fedex_envelope_zone_discounts, :fedex_discount_projection_id, :fedex_priority_overnight_discount_projection_id
    rename_column :fedex_pak_box_zone_discounts, :fedex_discount_projection_id, :fedex_priority_overnight_discount_projection_id
    rename_column :fedex_envelope_minimum_charges, :fedex_discount_projection_id, :fedex_priority_overnight_discount_projection_id
    rename_column :fedex_pak_box_minimum_charges, :fedex_discount_projection_id, :fedex_priority_overnight_discount_projection_id
  end

  def down
    # Revert column renames in related tables
    rename_column :fedex_pak_box_minimum_charges, :fedex_priority_overnight_discount_projection_id, :fedex_discount_projection_id
    rename_column :fedex_envelope_minimum_charges, :fedex_priority_overnight_discount_projection_id, :fedex_discount_projection_id
    rename_column :fedex_pak_box_zone_discounts, :fedex_priority_overnight_discount_projection_id, :fedex_discount_projection_id
    rename_column :fedex_envelope_zone_discounts, :fedex_priority_overnight_discount_projection_id, :fedex_discount_projection_id
    rename_column :fedex_discount_basics, :fedex_priority_overnight_discount_projection_id, :fedex_discount_projection_id

    # Revert the main table rename
    rename_table :fedex_priority_overnight_discount_projections, :fedex_discount_projections
  end
end
