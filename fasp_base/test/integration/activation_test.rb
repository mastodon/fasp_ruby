require "test_helper"

class ActivationTest < ActionDispatch::IntegrationTest
  include FaspBase::IntegrationTestHelper

  setup do
    @server = fasp_base_servers(:mastodon_server)
    FaspBase.capabilities = [
      { id: "test", version: "5.4" }
    ]
  end

  teardown do
    FaspBase.capabilities = []
  end

  test "POST /fasp/capabilities/:name/:version/activation enables capability" do
    post fasp_base.fasp_capability_activation_path("test", version: "5"),
      as: :json,
      headers: request_authentication_headers(@server, :post, fasp_base.fasp_capability_activation_url("test", version: "5"), "")

    assert_response :no_content
    assert @server.reload.capability_enabled?("test", version: 5)
  end

  test "DELETE /fasp/capabilities/:name/:version/activation disables capability" do
    @server.enable_capability!("test", version: 5)

    delete fasp_base.fasp_capability_activation_path("test", version: "5"),
      as: :json,
      headers: request_authentication_headers(@server, :delete, fasp_base.fasp_capability_activation_url("test", version: "5"), "")

    assert_response :no_content
    assert_not @server.reload.capability_enabled?("test", version: 5)
  end
end
