class Product < ApplicationRecord
    def self.search(search)
        where("(name LIKE ?) OR (brand LIKE ?) OR (status LIKE ?)", "%#{search}%", "%#{search}%", "%#{search}%")
    end
    paginates_per 5
    validates :name, :uniqueness => {:scope => :brand}
end
