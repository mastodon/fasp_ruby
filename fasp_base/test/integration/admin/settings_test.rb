require "test_helper"

module Admin
  class SettingsTest < ActionDispatch::IntegrationTest
    include FaspBase::IntegrationTestHelper

    test "signed out users cannot access settings" do
      get fasp_base.admin_settings_path

      assert_redirected_to fasp_base.new_admin_session_path
    end

    test "it shows the settings" do
      sign_in_admin(fasp_base_admin_users(:provider_admin))

      get fasp_base.admin_settings_path

      assert_response :success
    end

    test "it allows changing a setting" do
      sign_in_admin(fasp_base_admin_users(:provider_admin))

      patch fasp_base.admin_setting_path(fasp_base_settings(:registration)),
        params: { setting: { value: "closed" } }

      assert FaspBase::Setting.get("registration").closed?
    end
  end
end
