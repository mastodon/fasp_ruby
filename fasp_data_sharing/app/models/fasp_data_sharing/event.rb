class FaspDataSharing::Event
  include ActiveModel::Model
  include ActiveModel::Attributes

  LIFECYCLE_EVENTS = %w[new update delete].freeze
  JOB_CLASSES = {
    "subscription" => {
      "content" => {
        "new" => FaspDataSharing::ProcessNewContentJob,
        "update" => FaspDataSharing::ProcessContentUpdateJob,
        "delete" => FaspDataSharing::ProcessContentDeletionJob,
        "trending" => FaspDataSharing::ProcessTrendingContentJob
      },
      "account" => {
        "new" => FaspDataSharing::ProcessNewAccountJob,
        "update" => FaspDataSharing::ProcessAccountUpdateJob,
        "delete" => FaspDataSharing::ProcessAccountDeletionJob
      }
    },
    "backfillRequest" => {
      "content" => {
        nil => FaspDataSharing::ProcessContentBackfillJob
      },
      "account" => {
        nil => FaspDataSharing::ProcessAccountBackfillJob
      }
    }
  }.freeze

  attribute :source
  attribute :category, :string
  attribute :event_type, :string
  attribute :more_objects_available, :boolean
  attribute :object_uris

  validates :source, presence: true
  validates :category, presence: true, inclusion: FaspDataSharing::Subscription::CATEGORIES
  validates :object_uris, presence: true

  validate :source_is_known
  validate :source_matches_event

  def process
    return unless valid?

    job_class = JOB_CLASSES[source.keys.first][category][event_type]
    jobs = object_uris.map { |uri| job_class.new(uri) }
    ActiveJob.perform_all_later(jobs)

    update_backfill_request
  end

  private

  def update_backfill_request
    return unless backfill_event?

    @source_record.mark_as_fulfilled! unless more_objects_available
  end

  def source_is_known
    case source&.keys.first
    when "subscription"
      @source_record = FaspDataSharing::Subscription.find_by(remote_id: source["subscription"]["id"])
    when "backfillRequest"
      @source_record = FaspDataSharing::BackfillRequest.find_by(remote_id: source["backfillRequest"]["id"])
    else
      errors.add(:source, :unknown)
    end
  rescue ActiveRecord::RecordNotFound
    errors.add(:source, :unknown)
  end

  def source_matches_event
    return if valid_subscription_event? || valid_backfill_event?

    errors.add(:source, :does_not_match)
  end

  def valid_subscription_event?
    subscription_event? &&
      @source_record.category == category &&
      (valid_lifecycle_event? || valid_trending_event?)
  end

  def valid_lifecycle_event?
    @source_record.subscription_type == "lifecycle" &&
      event_type.in?(LIFECYCLE_EVENTS)
  end

  def valid_trending_event?
    @source_record.subscription_type == "trends" &&
      event_type == "trending"
  end

  def valid_backfill_event?
    backfill_event? && @source_record.category == category
  end

  def subscription_event?
    @source_record.is_a?(FaspDataSharing::Subscription)
  end

  def backfill_event?
    @source_record.is_a?(FaspDataSharing::BackfillRequest)
  end
end
