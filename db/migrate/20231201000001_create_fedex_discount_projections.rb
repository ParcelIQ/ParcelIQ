class CreateFedexDiscountProjections < ActiveRecord::Migration[7.0]
  def change
    create_table :fedex_discount_projections do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
