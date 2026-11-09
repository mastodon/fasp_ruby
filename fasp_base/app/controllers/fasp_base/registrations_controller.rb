module FaspBase
  class RegistrationsController < ApplicationController
    skip_authentication

    before_action :registration_allowed

    def new
      session[:return_to_server] = params[:return_to_server] if params[:return_to_server].present?

      @registration = ManualRegistration.new
    end

    def create
      @registration = ManualRegistration.new(registration_params)

      if @registration.valid?
        @registration.save!
        self.current_user = @registration.user

        respond_to do |format|
          format.html { redirect_to_proper_target }
          format.json { head :created }
        end
      else
        respond_to do |format|
          format.html { render action: :new }
          format.json { head :unprocessable_entity }
        end
      end
    end

    private

    def redirect_to_proper_target
      if session[:return_to_server].present?
        query = { return_id: session.delete(:return_to_server) }

        redirect_to @registration.server.url("/registration_completion?#{query.to_query}"), allow_other_host: true
      else
        redirect_to server_path(@registration.server)
      end
    end

    def registration_params
      params.require(:registration)
        .permit(:email, :base_url, :password, :password_confirmation, :invitation_code)
    end

    def registration_allowed
      registration = FaspBase::Setting.get("registration")
      head :not_found if registration.closed? || registration.automatic?
    end
  end
end
