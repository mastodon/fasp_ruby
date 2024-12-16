class FaspDataSharing::ProcessContentDeletionJob < ApplicationJob
  queue_as :default

  def perform(uri)
    Content.where(uri:).destroy_all
  end
end
