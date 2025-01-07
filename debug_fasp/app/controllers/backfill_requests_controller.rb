class BackfillRequestsController < ApplicationController
  helper_method :current_server

  before_action :load_backfill_request, only: [ :update, :destroy ]

  def index
    @backfill_requests = FaspDataSharing::BackfillRequest
      .where(fasp_base_server: current_server).all
  end

  def create
    create_backfill_request

    redirect_to backfill_requests_path, notice: t(".success")
  end

  def update
    @backfill_request.continue!

    redirect_to backfill_requests_path, notice: t(".success")
  end

  def destroy
    @backfill_request.destroy

    redirect_to backfill_requests_path, notice: t(".success")
  end

  private

  def load_backfill_request
    @backfill_request = FaspDataSharing::BackfillRequest
      .where(fasp_base_server_id: current_user.server_ids)
      .find(params[:id])
  end

  def create_backfill_request
    case params[:type]
    when "content"
      FaspDataSharing::BackfillRequest.make(current_server, category: "content", max_count: 5)
    when "account"
      FaspDataSharing::BackfillRequest.make(current_server, category: "account", max_count: 5)
    end
  end
end
