class Brand < ApplicationRecord
    def self.search(search)
        where("(name LIKE ?) OR (status LIKE ?)", "%#{search}%", "%#{search}%")
    end
    
    validates :name, uniqueness: true
end
