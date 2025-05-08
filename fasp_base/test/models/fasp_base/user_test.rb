require "test_helper"

module FaspBase
  class UserTest < ActiveSupport::TestCase
    test "#activate! activates the user" do
      user = fasp_base_users(:inactive_admin)

      user.activate!

      assert user.active?
    end

    test "#deactivate! deactivates the user" do
      user = fasp_base_users(:fedi_admin)

      user.deactivate!

      refute user.active?
    end
  end
end
