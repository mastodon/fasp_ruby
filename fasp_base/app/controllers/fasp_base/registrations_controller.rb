module FaspBase
  class RegistrationsController < ApplicationController
    skip_authentication

    before_action :registration_allowed

    def new
      @registration = Registration.new
    end

    def create
      @registration = Registration.new(registration_params)

      if @registration.valid?
        @registration.save!
        self.current_user = @registration.user

        respond_to do |format|
          format.html { redirect_to server_path(@registration.server) }
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

    def registration_params
      params.require(:registration)
        .permit(:email, :base_url, :password, :password_confirmation)
    end

    def registration_allowed
      head :not_found unless FaspBase.registration_enabled?
    end
  end
end
