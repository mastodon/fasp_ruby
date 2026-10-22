require "test_helper"

module Fasp
  class RegistrationsTest < ActionDispatch::IntegrationTest
    test "registration with valid data" do
      fasp_base_settings(:registration).update!(value: "automatic")

      assert_difference -> { FaspBase::Server.count }, 1 do
        post fasp_base.fasp_registration_path,
          params: {
            baseUrl: "https://fedi.example.com/fasp",
            faspId: "dfkl3msw6ps3",
            publicKey: "KvVQVgD4/WcdgbUDWH7EVaYX9W7Jz5fGWt+Wg8h+YvI="
          }
      end

      assert_response :created

      new_server = FaspBase::Server.last

      # assert_redirected_to fasp_base.server_path(new_server)
      assert_equal "https://fedi.example.com/fasp", new_server.base_url
    end

    test "registration with invalid data" do
      fasp_base_settings(:registration).update!(value: "automatic")

      assert_no_difference -> { FaspBase::Server.count } do
        post fasp_base.fasp_registration_path,
          params: {
            baseUrl: "https://fedi.example.com/fasp"
          }
      end

      assert_response :unprocessable_content
    end

    test "registration without prior required manual registration" do
      assert_no_difference -> { FaspBase::Server.count } do
        post fasp_base.fasp_registration_path,
          params: {
            baseUrl: "https://fedi.example.com/fasp",
            faspId: "dfkl3msw6ps3",
            publicKey: "KvVQVgD4/WcdgbUDWH7EVaYX9W7Jz5fGWt+Wg8h+YvI="
          }
      end

      assert_response :forbidden
      expected_body = { "manualRegistration" => fasp_base.new_registration_url }
      assert_equal expected_body, response.parsed_body
    end

    test "registration attempt when registration is closed" do
      fasp_base_settings(:registration).update!(value: "closed")

      assert_no_difference -> { FaspBase::Server.count }, 1 do
        post fasp_base.fasp_registration_path,
          params: {
            baseUrl: "https://fedi.example.com/fasp",
            faspId: "dfkl3msw6ps3",
            publicKey: "KvVQVgD4/WcdgbUDWH7EVaYX9W7Jz5fGWt+Wg8h+YvI="
          }
      end

      assert_response :not_found
    end
  end
end
