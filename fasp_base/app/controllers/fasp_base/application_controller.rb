module FaspBase
  class ApplicationController < ActionController::Base
    include Authentication

    helper Rails.application.helpers

    layout "layouts/application"
  end
end
