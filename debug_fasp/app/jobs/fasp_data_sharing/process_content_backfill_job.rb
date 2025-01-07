class FaspDataSharing::ProcessContentBackfillJob < ApplicationJob
  queue_as :default

  def perform(uri)
    unless Content.where(uri:).exists?
      object = fetch_object(uri)
      Content.create!(
        uri: object["id"],
        object_type: object["type"],
        full_object: object
      )
    end
  end
end
