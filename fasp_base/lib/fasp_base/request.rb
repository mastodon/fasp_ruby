class FaspBase::Request
  def initialize(server)
    @server = server
  end

  def get(path)
    perform_request(:get, path)
  end

  def post(path, body: nil)
    perform_request(:post, path, body:)
  end

  def delete(pathl)
    perform_request(:delete, path)
  end

  private

  def perform_request(verb, path, body: nil)
    url = @server.url(path)
    body = body.present? ? body.to_json : ""
    key = Linzer.new_ed25519_key(@server.fasp_private_key_pem, @server.fasp_remote_id)
    session = HTTPX.with(headers: headers(body))
    request = session.build_request(verb, url, body:)
    ::Linzer.sign!(request, key:, components: %w[@method @target-uri content-digest])
    response = session.request(request)
    response.raise_for_status
    validate!(response)

    response.json unless response.body.empty?
  end

  def headers(body = "")
    {
      "accept" => "application/json",
      "content-type" => "application/json",
      "content-digest" => content_digest(body)
    }
  end

  def content_digest(body)
    "sha-256=:#{OpenSSL::Digest.base64digest("sha256", body || "")}:"
  end

  def validate!(response)
    content_digest_header = response.headers["content-digest"]
    raise "content-digest missing" if content_digest_header.blank?
    raise "content-digest does not match" if content_digest_header != content_digest(response.body)

    raise "signature-input is missing" if response.headers["signature-input"].blank?

    key = Linzer.new_ed25519_public_key(@server.public_key_pem)
    ::Linzer.verify!(response, key:)
  end
end
