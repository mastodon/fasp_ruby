class FaspDataSharing::ProcessNewAccountJob < ApplicationJob
  queue_as :default

  def perform(uri)
    unless Account.where(uri:).exists?
      object = fetch_object(uri)
      Account.create!(
        uri: object["id"],
        object_type: object["type"],
        full_object: object
      )
    end
  end
end
