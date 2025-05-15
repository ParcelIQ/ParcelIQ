class AddCompanyIdToFedexDiscountProjections < ActiveRecord::Migration[8.0]
  def up
    # Add the company_id column allowing null values initially
    add_reference :fedex_discount_projections, :company, null: true, foreign_key: true

    # Get the default company (first one) to assign to existing projections
    default_company = Company.first

    if default_company.present?
      # Update all existing projections with the default company
      execute <<-SQL
        UPDATE fedex_discount_projections
        SET company_id = #{default_company.id}
      SQL
    end

    # Now make the company_id column NOT NULL
    change_column_null :fedex_discount_projections, :company_id, false
  end

  def down
    remove_reference :fedex_discount_projections, :company
  end
end
