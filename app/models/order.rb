class Order < ApplicationRecord
    def self.search(search)
        where("(product LIKE ?) OR (brand LIKE ?) OR (status LIKE ?)", "%#{search}%" ,"%#{search}%" ,"%#{search}%")
    end
    paginates_per 5
    validates :amount, numericality: { greater_than: 0 }
end
