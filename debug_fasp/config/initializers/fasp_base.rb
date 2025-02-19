FaspBase.tap do |f|
  f.fasp_name = "Debug"
  f.domain = ENV["DOMAIN"] || ActionController::Base.default_url_options[:host] || "localhost:3000"
  f.capabilities = [
    { id: "callback", version: "0.1" },
    { id: "data_sharing", version: "0.1" }
  ]
  f.privacy_policy_url = ENV["PRIVACY_POLICY_URL"]
  f.privacy_policy_language = ENV["PRIVACY_POLICY_LANGUAGE"]
  f.contact_email = ENV["CONTACT_EMAIL"]
  f.fediverse_account = ENV["FEDIVERSE_ACCOUNT"]
  f.registration_enabled = ENV["DISABLE_SERVER_REGISTRATION"].present? ? false : true
end

Rails.application.config.to_prepare do
  FaspBase::Server.prepend FaspBase::ServerExtensions
end
