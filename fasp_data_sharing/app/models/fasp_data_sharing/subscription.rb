module FaspDataSharing
  class Subscription < ApplicationRecord
    CATEGORIES = %w[account content].freeze
    TYPES = %w[lifecycle trends].freeze
    DEFAULT_THRESHOLD = {
      timeframe: 15,
      shares: 3,
      likes: 3,
      replies: 3
    }.freeze

    belongs_to :fasp_base_server, class_name: "FaspBase::Server"

    validates :remote_id, presence: true
    validates :category, presence: true, inclusion: CATEGORIES
    validates :subscription_type, presence: true, inclusion: TYPES

    scope :content, -> { where(category: "content") }
    scope :account, -> { where(category: "account") }
    scope :lifecycle, -> { where(subscription_type: "lifecycle") }
    scope :trends, -> { where(subscription_type: "trends") }

    before_destroy :delete_on_server

    class << self
      def subscribe_to_content(server, max_batch_size: 50)
        category = "content"
        subscription_type = "lifecycle"
        remote_id = request_subscription(server, {
          category: category,
          subscriptionType: subscription_type,
          maxBatchSize: max_batch_size
        })

        create!(
          fasp_base_server: server, remote_id:, category:,
          subscription_type:, max_batch_size:
        )
      end

      def subscribe_to_accounts(server, max_batch_size: 50)
        category = "account"
        subscription_type = "lifecycle"
        remote_id = request_subscription(server, {
          category: category,
          subscriptionType: subscription_type,
          maxBatchSize: max_batch_size
        })

        create!(
          fasp_base_server: server, remote_id:, category:,
          subscription_type:, max_batch_size:
        )
      end

      def subscribe_to_trends(server, max_batch_size: 50, threshold: {})
        threshold.reverse_merge!(DEFAULT_THRESHOLD)
        category = "content"
        subscription_type = "trends"
        remote_id = request_subscription(server, {
          category:,
          subscriptionType: subscription_type,
          maxBatchSize: max_batch_size,
          threshold:
        })

        create!(
          fasp_base_server: server, remote_id:, category:,
          subscription_type:, max_batch_size:,
          threshold_timeframe: threshold[:timeframe],
          threshold_shares: threshold[:shares],
          threshold_likes: threshold[:likes],
          threshold_replies: threshold[:replies]
        )
      end

      private

      def request_subscription(server, payload)
        response = FaspBase::Request.new(server).post("/data_sharing/v0/event_subscriptions", body: payload)

        response["subscription"]["id"]
      end
    end

    private

    def delete_on_server
      FaspBase::Request.new(fasp_base_server).delete("/data_sharing/v0/event_subscriptions/#{remote_id}")
    end
  end
end
