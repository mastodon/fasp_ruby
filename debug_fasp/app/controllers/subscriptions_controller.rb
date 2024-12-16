class SubscriptionsController < ApplicationController
  def index
    @subscriptions = FaspDataSharing::Subscription.all
  end

  def create
    FaspDataSharing::Subscription.subscribe_to_content(current_user.servers.first)

    redirect_to subscriptions_path, notice: t(".success")
  end

  def destroy
    subscription = FaspDataSharing::Subscription.where(fasp_base_server_id: current_user.server_ids).find(params[:id])
    subscription.destroy

    redirect_to subscriptions_path, notice: t(".success")
  end
end
