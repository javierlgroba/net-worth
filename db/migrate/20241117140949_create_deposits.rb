class CreateDeposits < ActiveRecord::Migration[7.2]
  def change
    create_table :deposits do |t|
      t.string :name
      t.float :apr
      t.float :tax
      t.date :maturity_date
      t.float :start_balance
      t.string :currency

      t.timestamps
    end
    add_reference :deposits, :account_provider, null: true, foreign_key: true
  end
end
