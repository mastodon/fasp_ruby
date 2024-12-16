module FaspBase::IntegrationTestHelper
  private

  def request_authentication_headers(server, verb, uri, params)
    params = encode_body(params)
    headers = {}
    headers["content-digest"] = content_digest(params)
    request = Linzer.new_request(verb, uri, {}, headers)
    key = private_key_for(server)
    signature = sign(request, key, %w[@method @target-uri content-digest])
    headers.merge(signature.to_h)
  end

  def response_authentication_headers(server, status, body)
    headers = {}
    headers["content-digest"] = content_digest(body)
    response = Linzer.new_response(body, status, headers)
    key = private_key_for(server)
    signature = sign(response, key, %w[@status content-digest])
    headers.merge(signature.to_h)
  end

  def stub_request_to(server, method, path, response_status, response_body)
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

    {
      id: server.id.to_s,
      private_key: @cached_server_keys[server].private_to_pem
    }
  end

  def sign(request_or_response, key, components)
    message = Linzer::Message.new(request_or_response)
    linzer_key = Linzer.new_ed25519_key(key[:private_key], key[:id])
    signature = Linzer.sign(linzer_key, message, components)
    signature
  end

  def encode_body(body)
    return body if body.nil? || body.is_a?(String)

    encoder = ActionDispatch::RequestEncoder.encoder(:json)
    encoder.encode_params(body)
  end

  def content_digest(content)
    "sha-256=:#{OpenSSL::Digest.base64digest("sha256", content)}:"
  end
end
