require "test_helper"

class RegistrationTest < ActionDispatch::IntegrationTest
  include StubbedRequests

  setup do
    stub_fasp_registration
  end

  test "disabled registration" do
    fasp_base_settings(:registration).update!(value: "closed")

    get fasp_base.new_registration_path

    assert_response :not_found

    post fasp_base.registration_path, params: {
      registration: {
        email: "user@example.com",
        password: "super_secret",
        password_confirmation: "super_secret",
        base_url: "https://fedi.example.com/fasp"
      }
    }

    assert_response :not_found
  end

  test "requesting the registration form" do
    get fasp_base.new_registration_path

    assert_response :success
  end

  test "registration with valid data" do
    assert_difference [ -> { FaspBase::User.count }, -> { FaspBase::Server.count } ], 1 do
      post fasp_base.registration_path,
        params: {
          registration: {
            email: "user@example.com",
            password: "super_secret",
            password_confirmation: "super_secret",
            base_url: "https://fedi.example.com/fasp"
          }
        }
    end

    new_user = FaspBase::User.last
    new_server = new_user.servers.first

    assert_redirected_to fasp_base.server_path(new_server)
    assert_equal "user@example.com", new_user.email
    assert_equal "https://fedi.example.com/fasp", new_server.base_url
  end

  test "registration with invalid data" do
    assert_no_difference [ -> { FaspBase::User.count }, -> { FaspBase::Server.count } ] do
      post fasp_base.registration_path,
        params: {
          registration: {
            email: "user",
            password: "pw",
            password_confirmation: "op",
            base_url: "/fasp"
          }
        }
    end

    assert_response :success
  end

  test "registration without invitiation code if required" do
    fasp_base_settings(:registration).update!(value: "invite_only")

    assert_no_difference [ -> { FaspBase::User.count }, -> { FaspBase::Server.count } ] do
      post fasp_base.registration_path,
        params: {
          registration: {
            email: "user@example.com",
            password: "super_secret",
            password_confirmation: "super_secret",
            base_url: "https://fedi.example.com/fasp"
          }
        }
    end

    assert_response :success
  end

  test "registration with valid invitation code" do
    fasp_base_settings(:registration).update!(value: "invite_only")

    assert_difference [ -> { FaspBase::User.count }, -> { FaspBase::Server.count } ], 1 do
      post fasp_base.registration_path,
        params: {
          registration: {
            email: "user@example.com",
            password: "super_secret",
            password_confirmation: "super_secret",
            base_url: "https://fedi.example.com/fasp",
            invitation_code: "abcdefg"
          }
        }
    end

    new_user = FaspBase::User.last
    new_server = new_user.servers.first

    assert_redirected_to fasp_base.server_path(new_server)
    assert_equal "user@example.com", new_user.email
    assert_equal "https://fedi.example.com/fasp", new_server.base_url
  end
end
