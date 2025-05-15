class CreateFedexDiscountBasicInternational < ActiveRecord::Migration[8.0]
  def change
    create_table :fedex_discount_basic_internationals do |t|
      t.integer :dim_divisor
      t.decimal :envelope_earned_discount
      t.decimal :pak_earned_discount
      t.decimal :box_earned_discount
      t.references :fedex_international_priority_import_discount_projection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
