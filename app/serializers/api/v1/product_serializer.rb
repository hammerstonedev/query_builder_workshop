class Api::V1::ProductSerializer < Api::V1::ApplicationSerializer
  set_type "product"

  attributes :id,
    :contact_id,
    :name,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :contact, serializer: Api::V1::ContactSerializer
end
