module FaspBase
  class HostMetaController < ApplicationController
    skip_authentication

    def show
      respond_to do |format|
        format.json { render json: host_meta }
      end
    end

    private

    def host_meta
      links = [ {
        "href" => FaspBase.base_url,
        "rel" => "https://fasp.dev/ns#baseUrl"
      } ]

      links << {
        "href" => new_registration_url,
        "rel" => "https://fasp.dev/ns#manualRegistration"
      } if FaspBase::Setting.get("registration").in?(%w[manual invite_only])

      { "links" => links }
    end
  end
end
