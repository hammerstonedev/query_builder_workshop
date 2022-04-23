require "test_helper"
require "controllers/api/test"

class Api::V1::ProductsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @contact = create(:contact, team: @team)
@product = create(:product, contact: @contact)
      @other_products = create_list(:product, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(product_data)
      # Fetch the product in question and prepare to compare it's attributes.
      product = Product.find(product_data["id"])

      assert_equal product_data['name'], product.name
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal product_data["contact_id"], product.contact_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/contacts/#{@contact.id}/products", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      product_ids_returned = response.parsed_body.dig("data").map { |product| product.dig("attributes", "id") }
      assert_includes(product_ids_returned, @product.id)

      # But not returning other people's resources.
      assert_not_includes(product_ids_returned, @other_products[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/products/#{@product.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/products/#{@product.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      product_data = Api::V1::ProductSerializer.new(build(:product, contact: nil)).serializable_hash.dig(:data, :attributes)
      product_data.except!(:id, :contact_id, :created_at, :updated_at)

      post "/api/v1/contacts/#{@contact.id}/products",
        params: product_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/contacts/#{@contact.id}/products",
        params: product_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/products/#{@product.id}", params: {
        access_token: access_token,
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @product.reload
      assert_equal @product.name, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/products/#{@product.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Product.count", -1) do
        delete "/api/v1/products/#{@product.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/products/#{@product.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
end
