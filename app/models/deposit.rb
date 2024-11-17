class Deposit < ApplicationRecord
  belongs_to :account_provider, optional: true
end
