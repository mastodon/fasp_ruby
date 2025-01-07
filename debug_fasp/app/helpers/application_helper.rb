module ApplicationHelper
  include FaspBase::ApplicationHelper

  DATA_SHARING_TABS = {
    subscriptions: :subscriptions_path,
    backfill_requests: :backfill_requests_path,
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

  def nav_link_to(*args, **kwargs)
    link_to(*args, **(kwargs.merge(class: "text-gray-600 font-medium px-2 py-1 rounded hover:bg-blue-200 hover:text-gray-700")))
  end
end
