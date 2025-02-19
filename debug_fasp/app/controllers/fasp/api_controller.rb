# Base controller for all FASP API controllers
class Fasp::ApiController < ActionController::Base
  include FaspBase::ApiAuthentication
end
