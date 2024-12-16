require "test_helper"

module FaspDataSharing
  class SubscriptionTest < ActiveSupport::TestCase
    include FaspBase::IntegrationTestHelper

    setup do
      @server = fasp_base_servers(:fedi_server)
      stub_request_to(@server, :post, "/data_sharing/v0/event_subscriptions", 201,
        {
          subscription: {
            id: "23"
          }
        }
      )
    end

    test "creating a trends subscription" do
      subscription = Subscription.subscribe_to_trends(@server, threshold: { timeframe: 30 })

      assert_equal "23", subscription.remote_id
      assert_equal @server, subscription.fasp_base_server
      assert_equal "content", subscription.category
      assert_equal "trends", subscription.subscription_type
      assert_equal 30, subscription.threshold_timeframe
    end

    test "creating a lifecycle subscription for content" do
      subscription = Subscription.subscribe_to_content(@server, max_batch_size: 100)

      assert_equal "23", subscription.remote_id
      assert_equal @server, subscription.fasp_base_server
      assert_equal "content", subscription.category
      assert_equal "lifecycle", subscription.subscription_type
      assert_equal 100, subscription.max_batch_size
    end

    test "creating a lifecycle subscription for accounts" do
      subscription = Subscription.subscribe_to_accounts(@server, max_batch_size: 80)

      assert_equal "23", subscription.remote_id
      assert_equal @server, subscription.fasp_base_server
      assert_equal "account", subscription.category
      assert_equal "lifecycle", subscription.subscription_type
      assert_equal 80, subscription.max_batch_size
    end
  end
end
