require "test_helper"

module FaspBase
  class RegistrationTest < ::ActiveSupport::TestCase
    test "#save! creates user and server" do
      registration = Registration.new(
        email: "admin@fedi.example.com",
        base_url: "https://fedi.example.com/fasp",
        password: "super_secret",
        password_confirmation: "super_secret"
      )

      assert_difference [ -> { User.count }, -> { Server.count } ], 1 do
        registration.save!
      end
    end
  end
end
