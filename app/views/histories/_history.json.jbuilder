json.extract! history, :id, :order_code, :brand, :product, :amount, :created_at, :updated_at
json.url history_url(history, format: :json)
