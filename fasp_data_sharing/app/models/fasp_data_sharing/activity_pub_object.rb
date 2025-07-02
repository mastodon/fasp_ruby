class FaspDataSharing::ActivityPubObject
  include ActiveModel::Model
  include ActiveModel::Attributes

  EMPTY_DIGEST = "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU="

  attribute :uri, :string

  def fetch
    response = message_signature_request

    response.raise_for_status

    response = signature_request if response.status.in?([ 401, 403 ])

    JSON.parse(response.body.to_s) # TODO: simplify with response.json after next httpx release
  end

  private

  def message_signature_request
    base_headers = {
      "accept" => "application/activity+json",
      "content-digest" => "sha-256=:#{EMPTY_DIGEST}:"
    }
    key = Linzer.new_rsa_pss_sha512_key(private_key_pem, keyid)
    session = HTTPX.with(headers: base_headers)
    request = session.build_request(:get, uri)
    Linzer.sign!(request, key:, components: %w[@method @target-uri content-digest])
    session.request(request)
  end

  # Forces HTTP 1.1 because http/2 does not allow the `Host` header we sign
  def signature_request
    HTTPX.with(ssl: { alpn_protocols: %w[http/1.1] }, headers: signature_headers).get(uri)
  end

  def signature_headers
    base_headers = {
      "accept" => "application/activity+json",
      "digest" => "SHA-256=#{EMPTY_DIGEST}",
      "date" => Time.now.utc.httpdate,
      "host" => URI(uri).host
    }
    signature_header = [
      "keyId=\"#{keyid}\"",
      'algorithm="rsa-sha256"',
      'headers="(request-target) date digest host"',
      "signature=\"#{sign(base_headers)}\""
    ].join(",")
    base_headers.merge("signature" => signature_header)
  end

  def sign(headers)
    parsed_uri = URI(uri)
    target = parsed_uri.path
    target << "?#{parsed_uri.query}" unless parsed_uri.query.nil?
    string = [
      "(request-target): get #{target}",
      "date: #{headers["date"]}",
      "digest: #{headers["digest"]}",
      "host: #{headers["host"]}"
    ].join("\n")
    key = OpenSSL::PKey.read(private_key_pem)
    Base64.strict_encode64(key.sign("sha256", string))
  end

  def keyid
    @keyid ||= "#{FaspBase.base_url}/actor#main-key"
  end

  def private_key_pem
    @private_key_pem ||= FaspDataSharing::Actor.instance.private_key_pem
  end
end
