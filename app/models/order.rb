class Order < ApplicationRecord
    paginates_per 5
    validates :amount, numericality: { greater_than: 0 }
end
