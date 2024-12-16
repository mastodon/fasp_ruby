module FaspDataSharing
  class WebfingerController < ApplicationController
    before_action :check_resource

    def show
      render json: webfinger_json, content_type: "application/jrd+json"
    end

    private

    def actor
      @actor ||= Actor.instance
    end

    def actor_url
      @actor_url ||= "#{FaspBase.base_url}/actor"
    end

    def actor_acct_uri
      @actor_acct_uri ||= "acct:#{actor.username}@#{FaspBase.domain}"
    end

    def check_resource
      raise ActionController::RoutingError, "unknown account" unless params[:resource] == actor_acct_uri
    end

    def webfinger_json
      {
        subject: actor_acct_uri,
        aliases: [ actor_url ],
        links: [ {
          rel: "self",
          type: "application/activity+json",
          href: actor_url
        } ]
      }
    end
  end
end
