class SubscriptionsController < ApplicationController
  helper_method :current_server

  def index
    @subscriptions = FaspDataSharing::Subscription
      .where(fasp_base_server: current_server).all
  end

  def create
    create_subscription

    redirect_to subscriptions_path, notice: t(".success")
  end

  def destroy
    subscription = FaspDataSharing::Subscription.where(fasp_base_server_id: current_user.server_ids).find(params[:id])
    subscription.destroy

    redirect_to subscriptions_path, notice: t(".success")
  end

  private

  def create_subscription
    case params[:type]
    when "content"
      FaspDataSharing::Subscription.subscribe_to_content(current_server)
    when "account"
      FaspDataSharing::Subscription.subscribe_to_accounts(current_server)
    when "trends"
      FaspDataSharing::Subscription.subscribe_to_trends(current_server)
    end
  end
end
