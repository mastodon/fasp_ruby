class FaspBase::Request
  def initialize(server)
    @server = server
  end

  def get(path)
    url = @server.url(path)
    response = HTTPX.with(headers: headers("GET", url)).get(url)
    response.raise_for_status
    validate!(response)

    response.json
  end

  def post(path, body: nil)
    url = @server.url(path)
    body = body.to_json
    response = HTTPX.with(headers: headers("POST", url, body)).post(url, body:)
    response.raise_for_status
    validate!(response)

    response.json unless response.body.empty?
  end

  def delete(path)
    url = @server.url(path)
    response = HTTPX.with(headers: headers("DELETE", url)).delete(url)
    response.raise_for_status
    validate!(response)

    true
  end

  private

  def headers(verb, url, body = "")
    result = {
      "accept" => "application/json",
      "content-type" => "application/json",
      "content-digest" => content_digest(body)
    }
    result.merge(signature_headers(verb, url, result))
  end

  def content_digest(body)
    "sha-256=:#{OpenSSL::Digest.base64digest("sha256", body || "")}:"
  end

  def signature_headers(verb, url, headers)
    linzer_request = Linzer.new_request(verb, url, {}, headers)
    message = Linzer::Message.new(linzer_request)
    key = Linzer.new_ed25519_key(@server.fasp_private_key_pem, @server.fasp_remote_id)
    signature = Linzer.sign(key, message, %w[@method @target-uri content-digest])

    signature.to_h
  end

  def validate!(response)
    content_digest_header = response.headers["content-digest"]
    raise "content-digest missing" if content_digest_header.blank?
    raise "content-digest does not match" if content_digest_header != content_digest(response.body)

    signature_input = response.headers["signature-input"].encode("UTF-8")
    raise "signature-input is missing" if signature_input.blank?

    linzer_response = Linzer.new_response(
      response.body,
      response.status,
      {
        "content-digest" => content_digest_header,
        "signature-input" => signature_input,
        "signature" => response.headers["signature"]
      }
    )
    message = Linzer::Message.new(linzer_response)
    key = Linzer.new_ed25519_public_key(@server.public_key_pem)
    signature = Linzer::Signature.build(message.headers)
    Linzer.verify(key, message, signature)
  end
end
