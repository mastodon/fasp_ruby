require "fasp_base/version"
require "fasp_base/engine"
require "fasp_base/integration_test_helper"
require "fasp_base/request"

module FaspBase
  class Error < ::StandardError ; end

  mattr_accessor :fasp_name, default: "Default FASP"
  mattr_accessor :domain, default: "fasp.example.com"
  mattr_accessor :privacy_policy_url
  mattr_accessor :privacy_policy_language
  mattr_accessor :capabilities, default: []
  mattr_accessor :contact_email
  mattr_accessor :fediverse_account

  def self.base_url
    protocol = Rails.env.production? ? "https" : "http"
    "#{protocol}://#{domain}/fasp"
  end
end
