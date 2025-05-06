class ApplicationController < ActionController::Base
  include FaspBase::Authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  default_form_builder FaspBase::FormBuilder

  private

  # Currently ever user can only have one server but this will probably
  # change soon.
  def current_server
    @current_server ||= current_user&.servers&.first
  end
end
