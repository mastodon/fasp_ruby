require "test_helper"

class ProviderInfoTest < ActionDispatch::IntegrationTest
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
    get fasp_base.fasp_provider_info_path, as: :json, headers: { "Content-Digest" => EMPTY_DIGEST }.merge(signature_headers_for(**random_key))

    assert_response 401
  end

  test "access with valid digest and signature returns provider info" do
    headers = { "Content-Digest" => EMPTY_DIGEST }
      .merge(signature_headers_for(**existing_server_key))
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

  private

  def signature_headers_for(keyid:, key:)
    request = Linzer.new_request(:get, fasp_base.fasp_provider_info_url, {}, { "Content-Digest" => EMPTY_DIGEST })
    message = Linzer::Message.new(request)
    linzer_key = Linzer.new_ed25519_key(key.raw_private_key, keyid)
    signature = Linzer.sign(linzer_key, message, %w[@method @target-uri content-digest])
    signature.to_h
  end

  def random_key
    { keyid: "key#{rand(100..999)}", key: OpenSSL::PKey.generate_key("ed25519") }
  end

  def existing_server_key
    server = fasp_base_servers(:mastodon_server)
    key = OpenSSL::PKey.generate_key("ed25519")
    server.update!(public_key_pem: key.public_to_pem)
    { keyid: server.id.to_s, key: key }
  end
end
