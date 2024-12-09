require "test_helper"

class SessionsTest < ActionDispatch::IntegrationTest
  test "signed out users cannot access home" do
    get fasp_base.home_path

    assert_redirected_to fasp_base.new_session_path
  end

  test "it shows the sign in form" do
    get fasp_base.new_session_path

    assert_response :success
  end

  test "sign in with wrong credentials lead back to sign in form" do
    post fasp_base.session_path, params: { email: "a", password: "b" }

    assert_redirected_to fasp_base.new_session_path
  end

  test "successful sign in leads to home" do
    post fasp_base.session_path, params: { email: "fediadmin@example.com", password: "super_secret" }

    assert_redirected_to fasp_base.home_path

    get fasp_base.home_path

    assert_response :success
  end
end
