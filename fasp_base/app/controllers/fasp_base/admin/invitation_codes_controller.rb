module FaspBase
  class Admin::InvitationCodesController < Admin::BaseController
    def index
      @invitation_codes = FaspBase::InvitationCode.order(created_at: :desc)

      respond_to do |format|
        format.html
        format.json { render json: @invitation_codes }
      end
    end

    def create
      @invitation_code = FaspBase::InvitationCode.create!

      respond_to do |format|
        format.html do
          redirect_to fasp_base.admin_invitation_codes_path, notice: t(".success")
        end
        format.json { render json: @invitation_code, status: :created }
      end
    end

    def destroy
      invitation_code = FaspBase::InvitationCode.find(params[:id])
      invitation_code.destroy

      respond_to do |format|
        format.html do
          redirect_to fasp_base.admin_invitation_codes_path, notice: t(".success")
        end
        format.json { head :no_content }
      end
    end
  end
end
