class Product < ApplicationRecord
    paginates_per 5
    validates :name, :uniqueness => {:scope => :brand}
end
