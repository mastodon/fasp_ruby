module FaspBase
  class ManualRegistration
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
      end
    end
  end
end
