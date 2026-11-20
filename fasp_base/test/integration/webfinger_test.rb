require "test_helper"

class WebfingerTest < ActionDispatch::IntegrationTest
  setup do
    FaspBase.actor = true
    @actor = FaspBase::Actor.instance
  end

  teardown do
    FaspBase.actor = false
  end

  test "when actor support is disabled endpoint is not found" do
    FaspBase.actor = false

    get "/.well-known/webfinger?resource=acct:#{@actor.username}@#{FaspBase.domain}", as: :json

    assert_response :not_found
  end

  test "requesting the service actor succeeds" do
    get "/.well-known/webfinger?resource=acct:#{@actor.username}@#{FaspBase.domain}", as: :json

    assert_response :success
  end

  test "requesting an unknown actor does not work" do
    get "/.well-known/webfinger?resource=acct:unknown@#fedi@example.com", as: :json

    assert_response :not_found
  end
end
