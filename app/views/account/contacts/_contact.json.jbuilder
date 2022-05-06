json.extract! contact,
  :id,
  :team_id,
  :email,
  :first_name,
  :last_name,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_contact_url(contact, format: :json)
