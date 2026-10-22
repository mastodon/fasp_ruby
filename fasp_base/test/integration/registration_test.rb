require "test_helper"

class RegistrationTest < ActionDispatch::IntegrationTest
  test "closed registration" do
    disabled_registration("closed")
  end

  test "automatic registration" do
    disabled_registration("automatic")
  end

  test "requesting the registration form" do
    get fasp_base.new_registration_path

    assert_response :success
  end

  test "registration with valid data" do
    assert_difference [ -> { FaspBase::User.count }, -> { FaspBase::Server.count } ], 1 do
      post fasp_base.registration_path, params: valid_params
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

  test "registration with valid data and `return_to` with a matching URL" do
    get fasp_base.new_registration_path(return_to: "https://fedi.example.com/done")

    assert_difference [ -> { FaspBase::User.count }, -> { FaspBase::Server.count } ], 1 do
      post fasp_base.registration_path, params: valid_params
    end

    assert_redirected_to "https://fedi.example.com/done"
  end

  test "registration with valid data and `return_to` with a non-matching URL" do
    get fasp_base.new_registration_path(return_to: "https://other.example.com/done")

    assert_difference [ -> { FaspBase::User.count }, -> { FaspBase::Server.count } ], 1 do
      post fasp_base.registration_path, params: valid_params
    end

    new_server = FaspBase::Server.last

    assert_redirected_to fasp_base.server_path(new_server)
  end

  private

  def valid_params
    {
      registration: {
        email: "user@example.com",
        password: "super_secret",
        password_confirmation: "super_secret",
        base_url: "https://fedi.example.com/fasp"
      }
    }
  end

  def disabled_registration(setting = "closed")
    fasp_base_settings(:registration).update!(value: setting)

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
end
