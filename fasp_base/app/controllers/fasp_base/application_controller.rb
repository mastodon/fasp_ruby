module FaspBase
  class ApplicationController < ActionController::Base
    include Authentication

    helper Rails.application.helpers

    layout "layouts/application"

    default_form_builder FaspBase::FormBuilder

    private

    def require_actor_support_enabled
      raise ActionController::RoutingError, "not found" unless FaspBase.actor
    end
  end
end
