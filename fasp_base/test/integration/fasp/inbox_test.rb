require "test_helper"

class InboxTest < ActionDispatch::IntegrationTest
  setup do
    FaspBase.actor = true
  end

  teardown do
    FaspBase.actor = false
  end

  test "when actor support is disabled endpoint is not found" do
    FaspBase.actor = false

    get fasp_base.fasp_actor_inbox_url, as: :json

    assert_response :not_found
  end

  test "getting an actor" do
    get fasp_base.fasp_actor_inbox_url, as: :json

    assert_response :success
  end
end
