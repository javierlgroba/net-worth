class AddStockOrderReferences < ActiveRecord::Migration[7.2]
  def change
    add_reference :stock_orders, :stock, null: false, foreign_key: true
    add_reference :stock_orders, :account_provider, null: true, foreign_key: true
  end
end
