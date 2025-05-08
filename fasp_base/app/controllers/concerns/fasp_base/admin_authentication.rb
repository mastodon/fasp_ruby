module FaspBase
  module AdminAuthentication
    extend ActiveSupport::Concern

    included do
      helper_method :current_admin_user
      helper_method :admin_signed_in?

      before_action :require_admin_authentication
    end

    class_methods do
      def skip_admin_authentication(**options)
        skip_before_action :require_admin_authentication, **options
      end
    end

    private

    def current_admin_user
      @current_admin_user ||= AdminUser.find_by(id: session[:admin_user_id])
    end

    def current_admin_user=(admin_user)
      session[:admin_user_id] = admin_user.id
      @current_admin_user = admin_user
    end

    def admin_signed_in?
      current_admin_user.present?
    end

    def require_admin_authentication
      return if admin_signed_in?

      respond_to do |format|
        format.html { redirect_to fasp_base.new_admin_session_path }
        format.json { head status: 401 }
      end
    end
  end
end
