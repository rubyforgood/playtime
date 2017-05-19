json.extract! item, :id, :amazon_url, :associate_url, :price_cents, :asin, :created_at, :updated_at
json.url item_url(item, format: :json)
