module FaspDataSharing
  class BackfillRequest < ApplicationRecord
    CATEGORIES = %w[account content].freeze

    belongs_to :fasp_base_server, class_name: "FaspBase::Server"

    validates :remote_id, presence: true
    validates :category, presence: true, inclusion: CATEGORIES
    validates :max_count, numericality: { only_integer: true }

    class << self
      def make(server, category:, max_count: 100, cursor: nil)
        response = FaspBase::Request.new(server)
          .post("/data_sharing/v0/backfill_requests", body: {
            category:,
            maxCount: max_count,
            cursor:
          }.compact
        )

        remote_id = response["backfillRequest"]["id"]
        create!(
          fasp_base_server: server, remote_id:, category:,
          max_count:, cursor:
        )
      end
    end
  end
end
