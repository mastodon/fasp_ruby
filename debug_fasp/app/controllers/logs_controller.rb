class LogsController < ApplicationController
  def index
    @logs = Log
      .includes(:fasp_base_server)
      .where(fasp_base_server: { id: current_user.server_ids })
      .order(created_at: :desc)
  end

  def destroy
    log = Log.find(params[:id])
    log.destroy

    redirect_to logs_path, notice: t(".success")
  end
end
