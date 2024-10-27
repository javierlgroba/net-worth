class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :alias
      t.string :currency

      t.timestamps
    end
  end
end
