class Brand < ApplicationRecord
    paginates_per 5
    validates :name, uniqueness: true
end
