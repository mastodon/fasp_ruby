require "test_helper"

module FaspBase
  class SettingTest < ActiveSupport::TestCase
    test "::get returns the current value for the passed name" do
      assert_equal "open", FaspBase::Setting.get("registration")
      fasp_base_settings(:registration).update!(value: "closed")
      assert_equal "closed", FaspBase::Setting.get("registration")
    end

    test "::get returns an ActiveSupport::StringInquirer" do
      registration = FaspBase::Setting.get("registration")

      assert_kind_of ActiveSupport::StringInquirer, registration
      assert registration.open?
    end
  end
end
