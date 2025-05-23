module FaspBase::IntegrationTestHelper
  private

  def request_authentication_headers(server, verb, uri, params)
    params = encode_body(params)
    headers = { "content-digest" => content_digest(params) }
    request = HTTPX.with(headers:).build_request(verb, uri)
    key = private_key_for(server)
    Linzer.sign!(request, key:, components: %w[@method @target-uri content-digest])
    signature_headers(request)
  end

  def response_authentication_headers(server, status, body)
    fake_request = HTTPX.with(headers: {}).build_request(:get, "https://")
    headers = { "content-digest" => content_digest(body) }
    response = HTTPX::Response.new(fake_request, status, "1.1", headers)
    key = private_key_for(server)
    Linzer.sign!(response, key:, components: %w[@status content-digest])
    signature_headers(response)
  end

  def signature_headers(operation)
    headers = operation.headers
    {
      'content-digest' => headers['content-digest'],
      'signature-input' => headers['signature-input'],
      'signature' => headers['signature'],
    }
  end

  def stub_request_to(server, method, path, response_status, response_body = "")
    response_body = encode_body(response_body)
    response_headers = {
      "content-type" => "application/json"
    }.merge(response_authentication_headers(server, response_status, response_body))

    stub_request(method, server.url(path))
      .to_return do |request|
        {
          status: response_status,
          body: response_body,
          headers: response_headers
        }
      end
  end

  def private_key_for(server)
    @cached_server_keys ||= {}
    @cached_server_keys[server] ||=
      begin
        key = OpenSSL::PKey.generate_key("ed25519")
        server.update!(public_key_pem: key.public_to_pem)
        key
      end

    Linzer.new_ed25519_key(@cached_server_keys[server].private_to_pem, server.id.to_s)
  end

  def encode_body(body)
    return body if body.nil? || body.is_a?(String)

    encoder = ActionDispatch::RequestEncoder.encoder(:json)
    encoder.encode_params(body)
  end

  def content_digest(content)
    "sha-256=:#{OpenSSL::Digest.base64digest("sha256", content)}:"
  end

  def sign_in(user)
    post fasp_base.session_path, params: { email: user.email, password: "super_secret" }
  end

  def sign_in_admin(admin_user)
    post fasp_base.admin_session_path, params: { email: admin_user.email, password: "super_secret" }
  end
end
