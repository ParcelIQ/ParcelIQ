class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :string, default: 'customer'

    # Make company_id nullable for admin users
    change_column_null :users, :company_id, true
  end
end
