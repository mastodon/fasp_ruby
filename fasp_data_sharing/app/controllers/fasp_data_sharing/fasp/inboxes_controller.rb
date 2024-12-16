module FaspDataSharing
  class Fasp::InboxesController < ApplicationController
    def show
      render json: inbox_json, content_type: "application/activity+json"
    end

    def create
      head :ok
    end

    private

    def inbox_json
      {
        "@context" => "https://www.w3.org/ns/activitystreams",
        "type" => "OrderedCollection",
        "totalItems" => 0,
        "orderedItems" => []
      }
    end
  end
end
