class ChangeAccountProviderTypeFieldType < ActiveRecord::Migration[7.2]
  def change
    change_column :account_providers, :type, :integer, using: 'type::integer'
  end
end
