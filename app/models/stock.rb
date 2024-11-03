class Stock < ApplicationRecord
  has_many :stock_orders, dependent: :destroy
end
