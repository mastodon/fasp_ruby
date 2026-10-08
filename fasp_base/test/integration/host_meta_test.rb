require "test_helper"

class HostMetaTest < ActionDispatch::IntegrationTest
  setup do
    integration_session.host = FaspBase.domain
  end

  test "manual registration" do
    includes_base_url_and_registation
  end

  test "registration with invite code" do
    fasp_base_settings(:registration).update!(value: "invite_only")

    includes_base_url_and_registation
  end

  test "automatic registration" do
    fasp_base_settings(:registration).update!(value: "automatic")

    includes_base_url_only
  end

  test "disabled registration" do
    fasp_base_settings(:registration).update!(value: "closed")

    includes_base_url_only
  end

  private

  def includes_base_url_and_registation
    expected = {
      "links" => [
        {
          "href" => "http://fasp.example.com/fasp",
          "rel" => "https://fasp.dev/ns#baseUrl"
        },
        {
          "href" => "http://fasp.example.com/registration/new",
          "rel" => "https://fasp.dev/ns#manualRegistration"
        }
      ]
    }

    compare_host_meta_json(expected)
  end

  def includes_base_url_only
    expected = {
      "links" => [
        {
          "href" => "http://fasp.example.com/fasp",
          "rel" => "https://fasp.dev/ns#baseUrl"
        }
      ]
    }

    compare_host_meta_json(expected)
  end

  def compare_host_meta_json(expected)
    get "/.well-known/host-meta.json", as: :json

    assert_equal expected, response.parsed_body
  end
end
