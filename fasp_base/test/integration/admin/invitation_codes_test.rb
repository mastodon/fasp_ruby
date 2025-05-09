require "test_helper"

module Admin
  class InvitationCodesTest < ActionDispatch::IntegrationTest
    include FaspBase::IntegrationTestHelper

    test "signed out users cannot access invitation codes" do
      get fasp_base.admin_invitation_codes_path

      assert_redirected_to fasp_base.new_admin_session_path
    end

    test "it shows the list of codes" do
      sign_in_admin(fasp_base_admin_users(:provider_admin))

      get fasp_base.admin_invitation_codes_path

      assert_response :success
    end

    test "it created a new invitation code" do
      sign_in_admin(fasp_base_admin_users(:provider_admin))

      assert_difference -> { FaspBase::InvitationCode.count }, 1 do
        post fasp_base.admin_invitation_codes_path
      end
    end
  end
end
