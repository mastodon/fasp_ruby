require "test_helper"

class Fasp::Debug::V0::LogsTest < ActionDispatch::IntegrationTest
  include FaspBase::IntegrationTestHelper

  setup do
    # stub fediverse server
    @server = fasp_base_servers(:mastodon_server)
    stub_request_to(@server, :post, "/debug/v0/callback/responses", 201, "")
  end

  test "unauthenticated access is prohibited" do
    post fasp_debug_v0_callback_logs_path, as: :json, params: { hello: "world" }

    assert_response :unauthorized
  end

  test "authenticated request creates log entry" do
    payload = { hello: "world" }
    uri = fasp_debug_v0_callback_logs_url
    headers = request_authentication_headers(@server, :post, uri, payload)

    assert_difference -> { Log.count }, 1 do
      post fasp_debug_v0_callback_logs_path, as: :json, params: payload, headers: headers
    end

    assert_response :created
  end
end
