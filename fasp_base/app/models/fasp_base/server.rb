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

    def capability_enabled?(capability, version:)
      enabled_capabilities && enabled_capabilities.include?({ "id" => capability, "version" => version })
    end

    def enable_capability!(capability, version:)
      raise ArgumentError, "unsupported capability" unless FaspBase.supports?(capability, version:)
      self.enabled_capabilities ||= []
      enabled_capabilities << { "id" => capability, "version" => version.to_i }
      enabled_capabilities.uniq!
      save!
    end

    def disable_capability!(capability, version:)
      return if enabled_capabilities.blank?

      enabled_capabilities.delete({ "id" => capability, "version" => version.to_i })
      save!
    end

    private

    def create_keypair
      self.fasp_private_key_pem = OpenSSL::PKey
        .generate_key("ed25519")
        .private_to_pem
    end
  end
end
