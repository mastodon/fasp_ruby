module FaspBase
  class Admin::UsersController < Admin::BaseController
    def index
      @users = User.includes(:servers).order(created_at: :desc)

      respond_to do |format|
        format.html
        format.json { render json: @users }
      end
    end
  end
end
