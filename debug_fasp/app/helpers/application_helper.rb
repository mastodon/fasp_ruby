module ApplicationHelper
  DATA_SHARING_TABS = {
    subscriptions: :subscriptions_path,
    contents: :contents_path,
    accounts: :accounts_path,
    trend_signals: :trend_signals_path
  }.freeze

  def content_subscription_absent?
    FaspDataSharing::Subscription
      .where(fasp_base_server: current_server)
      .content
      .lifecycle
      .none?
  end

  def account_subscription_absent?
    FaspDataSharing::Subscription
      .where(fasp_base_server: current_server)
      .account
      .lifecycle
      .none?
  end

  def trends_subscription_absent?
    FaspDataSharing::Subscription
      .where(fasp_base_server: current_server)
      .content
      .trends
      .none?
  end
end
