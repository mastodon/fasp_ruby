module FaspDataSharing
  class Fasp::DataSharing::V0::AnnouncementsController < ApplicationController
    include FaspBase::ApiAuthentication

    def create
      event = Event.new(event_params)
      event.process

      respond_to do |format|
        format.json { head :no_content }
      end
    end

    private

    def event_params
      params
        .permit(:category, :eventType, :cursor, :moreObjectsAvailable, source: {}, objectUris: [])
        .to_unsafe_hash
        .transform_keys(&:underscore)
    end
  end
end
