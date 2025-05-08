module FaspBase
  class Admin::BaseController < ActionController::Base
    include AdminAuthentication

    helper Rails.application.helpers
    helper FaspBase::ApplicationHelper

    layout "layouts/admin"

    default_form_builder FaspBase::FormBuilder
  end
end
