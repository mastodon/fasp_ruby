module FaspBase
  class Server < ApplicationRecord
    belongs_to :user

    before_create :create_keypair

    def public_key
      @public_key ||= OpenSSL::PKey.read(public_key_pem)
    end

    def raw_public_key
      public_key.raw_public_key
    end

    def fasp_public_key_base64
      Base64.strict_encode64(fasp_private_key.raw_public_key)
    end

    def fasp_public_key_fingerprint
      OpenSSL::Digest.base64digest("sha256", fasp_private_key.raw_public_key)
    end

    def fasp_private_key
      @fasp_private_key ||= OpenSSL::PKey.read(fasp_private_key_pem)
    end

    def url(path)
      base = base_url
      base = base.chomp("/") if path.start_with?("/")
      "#{base}#{path}"
    end

    private

    def create_keypair
      self.fasp_private_key_pem = OpenSSL::PKey
        .generate_key("ed25519")
        .private_to_pem
    end
  end
end
