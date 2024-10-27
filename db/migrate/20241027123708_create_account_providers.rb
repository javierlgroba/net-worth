class CreateAccountProviders < ActiveRecord::Migration[7.2]
  def change
    create_table :account_providers do |t|
      t.string :name
      t.string :country
      t.string :type

      t.timestamps
    end
  end
end
