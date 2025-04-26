class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :subdomain
      t.string :domain
      t.string :time_zone
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone_number
      t.string :email
      t.string :website
      t.string :tax_id
      t.string :plan
      t.boolean :active
      t.jsonb :metadata
      t.jsonb :settings

      t.timestamps
    end
    add_index :companies, :subdomain, unique: true
    add_index :companies, :domain, unique: true
    add_index :companies, :active
  end
end
