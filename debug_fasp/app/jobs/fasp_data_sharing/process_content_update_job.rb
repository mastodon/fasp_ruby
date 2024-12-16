class FaspDataSharing::ProcessContentUpdateJob < ApplicationJob
  queue_as :default

  def perform(uri)
    object = fetch_object(uri)
    content = Content.find_or_initialize_by(uri:, object_type: object["type"])
    content.update(full_object: object)
  end
end
