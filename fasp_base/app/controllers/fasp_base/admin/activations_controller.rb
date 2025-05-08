module FaspBase
  class Admin::ActivationsController < Admin::BaseController
    before_action :load_user

    def create
      @user.activate!

      respond_to do |format|
        format.html { redirect_to fasp_base.admin_users_path, notice: t(".success") }
        format.json { head :created }
      end
    end

    def destroy
      @user.deactivate!

      respond_to do |format|
        format.html { redirect_to fasp_base.admin_users_path, notice: t(".success") }
        format.json { head :no_content }
      end
    end

    private

    def load_user
      @user = User.find(params[:user_id])
    end
  end
end
