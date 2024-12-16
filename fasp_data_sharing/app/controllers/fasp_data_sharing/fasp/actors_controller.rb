module FaspDataSharing
  class Fasp::ActorsController < ApplicationController
    def show
      render json: actor_json, content_type: "application/activity+json"
    end

    private

    def actor
      @actor ||= Actor.instance
    end

    def actor_json
      id = "#{FaspBase.base_url}/actor"
      {
        "@context" => [
          "https://www.w3.org/ns/activitystreams",
          "https://w3id.org/security/v1"
        ],
        "id" => id,
        "type" => "Application",
        "preferredUsername" => actor.username,
        "inbox" => fasp_data_sharing.fasp_actor_inbox_url,
        "outbox" => fasp_data_sharing.fasp_actor_outbox_url,
        "publicKey" => {
          "id" => "#{id}#main-key",
          "owner" => fasp_data_sharing.fasp_actor_url,
          "publicKeyPem" => actor.public_key_pem
        }
      }
    end
  end
end
