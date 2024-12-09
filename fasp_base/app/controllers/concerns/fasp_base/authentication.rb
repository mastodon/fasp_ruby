module FaspBase
  module Authentication
    extend ActiveSupport::Concern

    included do
      helper_method :current_user
      helper_method :signed_in?

      before_action :require_authentication
    end

    class_methods do
      def skip_authentication(**options)
        skip_before_action :require_authentication, **options
      end
    end

    private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end

    def current_user=(user)
      session[:user_id] = user.id
      @current_user = user
    end

    def signed_in?
      current_user.present?
    end

    def require_authentication
      return if signed_in?

      respond_to do |format|
        format.html { redirect_to fasp_base.new_session_path }
        format.json { head status: 401 }
      end
    end
  end
end
