class CreatePriorSpends < ActiveRecord::Migration[8.0]
  def change
    create_table :prior_spends do |t|
      t.references :company, null: false, foreign_key: true
      t.string :carrier, null: false
      t.string :spend_type, null: false
      t.string :service_type, null: false
      t.integer :shipment_count, default: 0
      t.decimal :spend_amount, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end

    add_index :prior_spends, [ :company_id, :carrier, :spend_type, :service_type ], name: 'index_prior_spends_on_company_carrier_spend_service'
  end
end
