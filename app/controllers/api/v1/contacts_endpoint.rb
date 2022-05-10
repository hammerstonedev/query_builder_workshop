class Api::V1::ContactsEndpoint < Api::V1::Root
  helpers do
    params :team_id do
      requires :team_id, type: Integer, allow_blank: false, desc: "Team ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Contact ID"
    end

    params :contact do
      optional :email, type: String, desc: Api.heading(:email)
      optional :first_name, type: String, desc: Api.heading(:first_name)
      optional :last_name, type: String, desc: Api.heading(:last_name)
      optional :pets, type: String, desc: Api.heading(:pets)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "teams", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Contact
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :team_id
    end
    oauth2
    paginate per_page: 100
    get "/:team_id/contacts" do
      @paginated_contacts = paginate @contacts
      render @paginated_contacts, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :team_id
      use :contact
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:team_id/contacts" do
      if @contact.save
        render @contact, serializer: Api.serializer
      else
        record_not_saved @contact
      end
    end
  end

  resource "contacts", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Contact
    end

    #
    # SHOW
    #

    desc Api.title(:show), &Api.show_desc
    params do
      use :id
    end
    oauth2
    route_param :id do
      get do
        render @contact, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :contact
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @contact.update(declared(params, include_missing: false))
          render @contact, serializer: Api.serializer
        else
          record_not_saved @contact
        end
      end
    end

    #
    # DESTROY
    #

    desc Api.title(:destroy), &Api.destroy_desc
    params do
      use :id
    end
    route_setting :api_resource_options, permission: :destroy
    oauth2 "delete"
    route_param :id do
      delete do
        render @contact.destroy, serializer: Api.serializer
      end
    end
  end
end
