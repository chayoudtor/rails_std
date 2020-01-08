class Brand < ApplicationRecord
    def self.search(search)
        where("(name LIKE ?) OR (status LIKE ?)", "%#{search}%", "%#{search}%")
    end

    paginates_per 5
    validates :name, uniqueness: true
end
