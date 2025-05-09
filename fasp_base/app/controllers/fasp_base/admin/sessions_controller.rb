module FaspBase
  class Admin::SessionsController < Admin::BaseController
    skip_admin_authentication

    def new
    end

    def create
      if admin_user = AdminUser.authenticate_by(params.permit(:email, :password))
        self.current_admin_user = admin_user

        redirect_to fasp_base.admin_users_path
      else
        redirect_to fasp_base.new_admin_session_path,
          alert: t(".failure")
      end
    end

    def destroy
      reset_session

      redirect_to fasp_base.new_admin_session_path,
        notice: t(".success")
    end
  end
end
