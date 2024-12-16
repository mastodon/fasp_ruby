class FaspDataSharing::ActivityPubObject
  include ActiveModel::Model
  include ActiveModel::Attributes

  EMPTY_DIGEST = "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU="

  attribute :uri, :string

  def fetch
    response = message_signature_request
    response = signature_request if response.status == 401

    response.raise_for_status
    JSON.parse(response.body.to_s) # TODO: simplify with response.json after next httpx release
  end

  private

  def message_signature_request
    request_with_headers(message_signature_headers)
  end

  def signature_request
    request_with_headers(signature_headers)
  end

  def request_with_headers(headers)
    HTTPX.with(headers:).get(uri)
  end

  def message_signature_headers
    base_headers = {
      "accept" => "application/activity+json",
      "content-digest" => "sha-256=:#{EMPTY_DIGEST}:"
    }

    linzer_request = Linzer.new_request("GET", uri, {}, base_headers)
    message = Linzer::Message.new(linzer_request)
    key = Linzer.new_rsa_pss_sha512_key(private_key_pem, keyid)
    signature = Linzer.sign(key, message, %w[@method @target-uri content-digest])
    base_headers.merge(signature.to_h)
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
