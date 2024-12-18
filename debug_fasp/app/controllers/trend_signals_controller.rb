class TrendSignalsController < ApplicationController
  def index
    @trend_signals = TrendSignal
      .includes(:content)
      .order(created_at: :desc)
  end

  def destroy
    trend_signal = TrendSignal.find(params[:id])
    trend_signal.destroy

    redirect_to trend_signals_path, notice: t(".success")
  end
end
