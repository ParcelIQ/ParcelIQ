class CreateFedexDiscountBasics < ActiveRecord::Migration[7.0]
  def change
    create_table :fedex_discount_basics do |t|
      t.references :fedex_discount_projection, null: false, foreign_key: true
      t.decimal :dim_divisor, precision: 10, scale: 2
      t.decimal :envelope_earned_discount, precision: 5, scale: 2
      t.decimal :pakbox_earned_discount, precision: 5, scale: 2
      t.timestamps
    end
  end
end
