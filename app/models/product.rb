class Product < ApplicationRecord
    def self.search(search)
        where("(name LIKE ?) OR (brand LIKE ?) OR (status LIKE ?)", "%#{search}%", "%#{search}%", "%#{search}%")
    end
    
    validates :name, :uniqueness => {:scope => :brand}
end
