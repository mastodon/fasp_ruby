module FaspBase
  class ApplicationController < ActionController::Base
    include Authentication

    layout "layouts/application"
  end
end
