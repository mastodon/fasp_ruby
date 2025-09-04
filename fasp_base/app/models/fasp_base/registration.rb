module FaspBase
  class Registration
    include ActiveModel::Model
    include ActiveModel::Attributes

    attr_reader :user, :server

    attribute :email, :string
    attribute :base_url, :string
    attribute :password, :string
    attribute :password_confirmation, :string
    attribute :invitation_code, :string

    # TODO: Better email validation
    validates :email,
      presence: true,
      format: { with: /@/ }
    validates :base_url,
      presence: true,
      "fasp_base/uri": { if: -> { Rails.env.production? } }
    validates :password,
      presence: true,
      confirmation: true,
      length: { minimum: 8 }
    validates :invitation_code,
      inclusion: {
        in: -> { InvitationCode.pluck(:code) },
        if: -> { Setting.get("registration").invite_only? }
      }

    def save!
      validate!

      User.transaction do
        @user = User.create!(email:, password:)
        @server = Server.create!(user:, base_url:)
        finish_registration
      end
    end

    private

    def finish_registration
      response = make_registration_request

      response.raise_for_status

      handle_response(response)
    end

    def make_registration_request
      HTTPX
        .post(
          @server.url("/registration"),
          json: {
            name: FaspBase.fasp_name,
            baseUrl: FaspBase.base_url,
            serverId: @server.id.to_s,
            publicKey: @server.fasp_public_key_base64
          }
        )
    end

    def handle_response(response)
      json = response.json
      @server.update!(
        fasp_remote_id: json["faspId"],
        public_key_pem: base64_to_pem(json["publicKey"]),
        registration_completion_uri: json["registrationCompletionUri"]
      )
    end

    def base64_to_pem(key)
      OpenSSL::PKey.new_raw_public_key(
        "ed25519",
        Base64.strict_decode64(key)
      ).public_to_pem
    end
  end
end
