class CreateFedexInternationalPriorityImportDiscountProjections < ActiveRecord::Migration[8.0]
  def change
    create_table :fedex_international_priority_import_discount_projections do |t|
      t.string :name
      t.references :company, null: false, foreign_key: true
      t.references :shipping_invoice, null: true, foreign_key: true

      t.timestamps
    end
  end
end
