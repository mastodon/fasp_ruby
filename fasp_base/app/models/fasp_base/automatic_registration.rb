module FaspBase
  class AutomaticRegistration
    include ActiveModel::Model
    include ActiveModel::Attributes

    attr_reader :server

    attribute :base_url, :string
    attribute :fasp_id, :string
    attribute :public_key, :string

    validates :base_url,
      presence: true,
      "fasp_base/uri": { if: -> { Rails.env.production? } }
    validates :fasp_id,
      presence: true
    validates :public_key,
      presence: true

    validate :public_key_parseable

    def initialize(attributes = {})
      super(
        base_url: attributes[:baseUrl],
        fasp_id: attributes[:faspId],
        public_key: attributes[:publicKey]
      )
    end

    def save!
      validate!

      @server =
        if FaspBase::Setting.get("registration").manual?
          Server.registration_unfinished.find_by!(base_url:)
        else
          Server.new(base_url:)
        end

      @server.public_key_pem = parsed_public_key
      @server.fasp_remote_id = fasp_id

      @server.save!
    end

    private

    def public_key_parseable
      parsed_public_key
    rescue
      errors.add(:public_key, :invalid)
    end

    def parsed_public_key
      OpenSSL::PKey.new_raw_public_key(
        "ed25519",
        Base64.strict_decode64(public_key)
      ).public_to_pem
    end
  end
end
