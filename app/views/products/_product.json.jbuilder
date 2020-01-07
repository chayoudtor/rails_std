json.extract! product, :id, :name, :brand, :status, :created_at, :updated_at
json.url product_url(product, format: :json)
