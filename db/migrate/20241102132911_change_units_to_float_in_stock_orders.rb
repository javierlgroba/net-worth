class ChangeUnitsToFloatInStockOrders < ActiveRecord::Migration[7.2]
  def change
    change_column :stock_orders, :units, :float
  end
end
