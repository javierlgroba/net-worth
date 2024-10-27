class RenameTypeInAccountProviders < ActiveRecord::Migration[7.2]
  def change
    rename_column :account_providers, :type, :provider_type
  end
end
