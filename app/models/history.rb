class History < ApplicationRecord
    def self.search(search)
        where("(brand LIKE ? ) OR (product LIKE ? )", "%#{search}%","%#{search}%")
    end
    
end
