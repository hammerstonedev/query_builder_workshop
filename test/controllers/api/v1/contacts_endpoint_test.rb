require "test_helper"
require "controllers/api/test"

class Api::V1::ContactsEndpointTest < Api::Test
  include Devise::Test::IntegrationHelpers

    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @contact = create(:contact, team: @team)
      @other_contacts = create_list(:contact, 3)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(contact_data)
      # Fetch the contact in question and prepare to compare it's attributes.
      contact = Contact.find(contact_data["id"])

      assert_equal contact_data['email'], contact.email
      assert_equal contact_data['first_name'], contact.first_name
      assert_equal contact_data['last_name'], contact.last_name
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal contact_data["team_id"], contact.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/contacts", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      contact_ids_returned = response.parsed_body.dig("data").map { |contact| contact.dig("attributes", "id") }
      assert_includes(contact_ids_returned, @contact.id)

      # But not returning other people's resources.
      assert_not_includes(contact_ids_returned, @other_contacts[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first.dig("attributes")
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/contacts/#{@contact.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      get "/api/v1/contacts/#{@contact.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      contact_data = Api::V1::ContactSerializer.new(build(:contact, team: nil)).serializable_hash.dig(:data, :attributes)
      contact_data.except!(:id, :team_id, :created_at, :updated_at)

      post "/api/v1/teams/#{@team.id}/contacts",
        params: contact_data.merge({access_token: access_token})

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/contacts",
        params: contact_data.merge({access_token: another_access_token})
      # TODO Why is this returning forbidden instead of the specific "Not Found" we get everywhere else?
      assert_response :forbidden
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/contacts/#{@contact.id}", params: {
        access_token: access_token,
        email: 'Alternative String Value',
        first_name: 'Alternative String Value',
        last_name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body.dig("data", "attributes")

      # But we have to manually assert the value was properly updated.
      @contact.reload
      assert_equal @contact.email, 'Alternative String Value'
      assert_equal @contact.first_name, 'Alternative String Value'
      assert_equal @contact.last_name, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/contacts/#{@contact.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Contact.count", -1) do
        delete "/api/v1/contacts/#{@contact.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/contacts/#{@contact.id}", params: {access_token: another_access_token}
      assert_response_specific_not_found
    end
end
