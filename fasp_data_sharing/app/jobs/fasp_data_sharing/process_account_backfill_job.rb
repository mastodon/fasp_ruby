# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessAccountBackfillJob < ApplicationJob
    queue_as :default

    def perform(*args)
      # Do something later
    end
  end
end
