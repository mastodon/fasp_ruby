class FaspDataSharing::ProcessAccountUpdateJob < ApplicationJob
  queue_as :default

  def perform(uri)
    object = fetch_object(uri)
    account = Account.find_or_initialize_by(uri:, object_type: object["type"])
    account.update(full_object: object)
  end
end
