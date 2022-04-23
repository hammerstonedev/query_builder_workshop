class Api::V1::ProductsEndpoint < Api::V1::Root
  helpers do
    params :contact_id do
      requires :contact_id, type: Integer, allow_blank: false, desc: "Contact ID"
    end

    params :id do
      requires :id, type: Integer, allow_blank: false, desc: "Product ID"
    end

    params :product do
      optional :name, type: String, desc: Api.heading(:name)
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.

      # 🚅 super scaffolding will insert processing for new fields above this line.
    end
  end

  resource "contacts", desc: Api.title(:collection_actions) do
    after_validation do
      load_and_authorize_api_resource Product
    end

    #
    # INDEX
    #

    desc Api.title(:index), &Api.index_desc
    params do
      use :contact_id
    end
    oauth2
    paginate per_page: 100
    get "/:contact_id/products" do
      @paginated_products = paginate @products
      render @paginated_products, serializer: Api.serializer
    end

    #
    # CREATE
    #

    desc Api.title(:create), &Api.create_desc
    params do
      use :contact_id
      use :product
    end
    route_setting :api_resource_options, permission: :create
    oauth2 "write"
    post "/:contact_id/products" do
      if @product.save
        render @product, serializer: Api.serializer
      else
        record_not_saved @product
      end
    end
  end

  resource "products", desc: Api.title(:member_actions) do
    after_validation do
      load_and_authorize_api_resource Product
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
        render @product, serializer: Api.serializer
      end
    end

    #
    # UPDATE
    #

    desc Api.title(:update), &Api.update_desc
    params do
      use :id
      use :product
    end
    route_setting :api_resource_options, permission: :update
    oauth2 "write"
    route_param :id do
      put do
        if @product.update(declared(params, include_missing: false))
          render @product, serializer: Api.serializer
        else
          record_not_saved @product
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
        render @product.destroy, serializer: Api.serializer
      end
    end
  end
end
