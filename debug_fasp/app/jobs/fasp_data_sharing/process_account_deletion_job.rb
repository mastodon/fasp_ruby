class FaspDataSharing::ProcessAccountDeletionJob < ApplicationJob
  queue_as :default

  def perform(uri)
    Account.where(uri:).destroy_all
  end
end
