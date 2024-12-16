module FaspDataSharing
  class Fasp::OutboxesController < ApplicationController
    def show
      render json: outbox_json, content_type: "application/activity+json"
    end

    private

    def outbox_json
      {
        "@context" => "https://www.w3.org/ns/activitystreams",
        "type" => "OrderedCollection",
        "totalItems" => 0,
        "orderedItems" => []
      }
    end
  end
end
