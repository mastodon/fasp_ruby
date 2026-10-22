module FaspBase
  class Fasp::RegistrationsController < ApplicationController
    skip_authentication

    before_action :registration_allowed

    def create
      @registration = AutomaticRegistration.new(registration_params)

      if @registration.valid?
        @registration.save!

        render json: fasp_info, status: :created
      else
        render json: ProblemDetails.new(@registration),
          status: :unprocessable_content,
          content_type: "application/problem+json"
      end

    rescue ActiveRecord::RecordNotFound
      render json: { manualRegistration: new_registration_url }, status: :forbidden
    end

    private

    def fasp_info
      {
        serverId: @registration.server.id.to_s,
        publicKey: @registration.server.fasp_public_key_base64
      }
    end

    def registration_allowed
      head :not_found if FaspBase::Setting.get("registration").closed?
    end

    def registration_params
      params.permit(:baseUrl, :faspId, :publicKey)
    end
  end
end
