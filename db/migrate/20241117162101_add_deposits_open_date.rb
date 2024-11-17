class AddDepositsOpenDate < ActiveRecord::Migration[7.2]
  def change
    add_column :deposits, :open_date, :date
  end
end
