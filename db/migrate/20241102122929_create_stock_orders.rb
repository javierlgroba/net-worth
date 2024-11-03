class CreateStockOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_orders do |t|
      t.integer :units
      t.float :unit_cost
      t.date :date

      t.timestamps
    end
  end
end
