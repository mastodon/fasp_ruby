# Overwrite this class in your fasp application
module FaspDataSharing
  class ProcessTrendingContentJob < ApplicationJob
    queue_as :default

    def perform(uri)
      content = Content.find_or_create_by!(uri:) do |c|
        object = fetch_object(uri)
        c.object_type = object["type"]
        c.full_object = object
      end
      TrendSignal.create!(content:)
    end
  end
end
