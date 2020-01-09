class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Set default global action for search 
  def self.index(sort_column, sort_direction, page_params, search_params = nil)
      if search_params
          all.search(search_params).order(sort_column + " " + sort_direction).page(page_params)
      else
          all.order(sort_column + " " + sort_direction).page(page_params)
      end
  end

  #  Number of column per page
  paginates_per 5
end
