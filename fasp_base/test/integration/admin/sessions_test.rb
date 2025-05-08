require "test_helper"

module Admin
  class SessionsTest < ActionDispatch::IntegrationTest
    test "signed out users cannot access users" do
      get fasp_base.admin_users_path

      assert_redirected_to fasp_base.new_admin_session_path
    end

    test "it shows the sign in form" do
      get fasp_base.new_admin_session_path

      assert_response :success
    end

    test "sign in with wrong credentials lead back to sign in form" do
      post fasp_base.admin_session_path, params: { email: "a", password: "b" }

      assert_redirected_to fasp_base.new_admin_session_path
    end

    test "successful sign in leads to users" do
      post fasp_base.admin_session_path, params: { email: "provider_admin@example.com", password: "super_secret" }

      assert_redirected_to fasp_base.admin_users_path

      get fasp_base.admin_users_path

      assert_response :success
    end
  end
end
