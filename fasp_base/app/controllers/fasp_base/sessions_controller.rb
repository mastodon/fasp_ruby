module FaspBase
  class SessionsController < ApplicationController
    skip_authentication

    def new
    end

    def create
      if user = User.authenticate_by(params.permit(:email, :password))
        self.current_user = user

        redirect_to fasp_base.home_path
      else
        redirect_to fasp_base.new_session_path,
          alert: t(".failure")
      end
    end

    def destroy
      reset_session

      redirect_to fasp_base.new_session_path,
        notice: t(".success")
    end
  end
end
