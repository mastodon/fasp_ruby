module FaspBase
  class Fasp::ActorsController < ApplicationController
    skip_authentication

    before_action :require_actor_support_enabled

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
        "inbox" => fasp_base.fasp_actor_inbox_url,
        "outbox" => fasp_base.fasp_actor_outbox_url,
        "publicKey" => {
          "id" => "#{id}#main-key",
          "owner" => fasp_base.fasp_actor_url,
          "publicKeyPem" => actor.public_key_pem
        }
      }
    end
  end
end
