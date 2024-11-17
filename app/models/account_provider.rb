class AccountProvider < ApplicationRecord
    enum provider_type: { bank: 0, broker: 1, both: 2 }
    validates :name, presence: true
    validates :country, presence: true, inclusion: { in: ISO3166::Country.codes }
    has_many :stock_orders
    has_many :deposits
end
