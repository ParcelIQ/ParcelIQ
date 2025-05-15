class AddShippingInvoiceIdToFedexDiscountProjections < ActiveRecord::Migration[8.0]
  def change
    add_reference :fedex_discount_projections, :shipping_invoice, null: true, foreign_key: true
  end
end
