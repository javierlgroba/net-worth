class StockOrder < ApplicationRecord
  belongs_to :stock
  belongs_to :account_provider, optional: true
end
