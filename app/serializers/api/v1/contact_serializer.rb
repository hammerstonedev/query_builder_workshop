class Api::V1::ContactSerializer < Api::V1::ApplicationSerializer
  set_type "contact"

  attributes :id,
    :team_id,
    :email,
    :first_name,
    :last_name,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :team, serializer: Api::V1::TeamSerializer
end
