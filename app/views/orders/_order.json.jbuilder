json.extract! order, :id, :product, :brand, :amount, :created_at, :updated_at
json.url order_url(order, format: :json)
