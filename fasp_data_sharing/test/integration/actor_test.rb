require "test_helper"

class ActorTest < ActionDispatch::IntegrationTest
  test "getting an actor" do
    get fasp_data_sharing.fasp_actor_url

    assert_response :success
  end
end
