class Fasp::ApiController < ActionController::Base
  include FaspBase::ApiAuthentication

  skip_forgery_protection
end
