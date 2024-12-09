module FaspBase::IntegrationTestHelper
  private

  def authentication_headers(verb, uri, params, key: existing_server_key)
    encoder = ActionDispatch::RequestEncoder.encoder(:json)
    body = encoder.encode_params(params)
    headers = {}
    headers["content-digest"] = content_digest(body)
    request = Linzer.new_request(verb, uri, {}, headers)
    message = Linzer::Message.new(request)
    linzer_key = Linzer.new_ed25519_key(key[:private_key], key[:id])
    signature = Linzer.sign(linzer_key, message, %w[@method @target-uri content-digest])
    headers.merge(signature.to_h)
  end

  def existing_server_key
    server = fasp_base_servers(:mastodon_server)
    key = OpenSSL::PKey.generate_key("ed25519")
    server.update!(public_key_pem: key.public_to_pem)
    { id: server.id.to_s, private_key: key.raw_private_key }
  end

  def content_digest(content)
    "sha-256=:#{OpenSSL::Digest.base64digest("sha256", content)}:"
  end
end
