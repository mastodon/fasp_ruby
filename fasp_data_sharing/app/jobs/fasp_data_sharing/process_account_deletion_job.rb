# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessAccountDeletionJob < ApplicationJob
    queue_as :default

    def perform(*args)
      # Do something later
    end
  end
end
