json.extract! product,
  :id,
  :contact_id,
  :name,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_product_url(product, format: :json)
