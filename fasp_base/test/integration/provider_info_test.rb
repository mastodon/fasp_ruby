require "test_helper"

class ProviderInfoTest < ActionDispatch::IntegrationTest
  include FaspBase::IntegrationTestHelper

  EMPTY_DIGEST = "sha-256=:47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=:"

  test "unauthenticated access is prohibited" do
    get fasp_base.fasp_provider_info_path, as: :json

    assert_response 401
  end

  test "access missing signature is prohibited" do
    get fasp_base.fasp_provider_info_path, as: :json, headers: { "Content-Digest" => EMPTY_DIGEST }

    assert_response 401
  end

  test "access with unknown signature is prohibited" do
    server = fasp_base_servers(:mastodon_server)
    headers = request_authentication_headers(server, :get, fasp_base.fasp_provider_info_url, "")
    server.destroy!
    get fasp_base.fasp_provider_info_path, as: :json, headers: headers

    assert_response 401
  end

  test "access with valid digest and signature returns provider info" do
    server = fasp_base_servers(:mastodon_server)
    headers = request_authentication_headers(server, :get, fasp_base.fasp_provider_info_url, "")
    get fasp_base.fasp_provider_info_path, as: :json, headers: headers

    assert_response 200

    expected_provider_info = {
      "name" => "FaspBase",
      "privacyPolicy" => [ {
        "url" => nil,
        "language" => nil
      } ],
      "capabilities" => [],
      "signInUrl" => "http://www.example.com/fasp_base/session/new",
      "contactEmail" => nil,
      "fediverseAccount" => nil
    }
    assert_equal expected_provider_info, response.parsed_body
  end
end
