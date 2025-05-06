module FaspBase
  class ApplicationController < ActionController::Base
    include Authentication

    helper Rails.application.helpers

    layout "layouts/application"

    default_form_builder FaspBase::FormBuilder
  end
end
