module FaspBase
  class Fasp::ProviderInfosController < ApplicationController
    include ApiAuthentication

    def show
      render json: provider_info
    end

    private

    def provider_info
      {
        name: FaspBase.name,
        privacyPolicy: [
          url: FaspBase.privacy_policy_url,
          language: FaspBase.privacy_policy_language
        ],
        capabilities: FaspBase.capabilities,
        signInUrl: fasp_base.new_session_url,
        contactEmail: FaspBase.contact_email,
        fediverseAccount: FaspBase.fediverse_account
      }
    end
  end
end
