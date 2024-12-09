require "test_helper"

module FaspBase
  class RegistrationTest < ::ActiveSupport::TestCase
    include StubbedRequests

    setup do
      stub_fasp_registration
    end

    test "#save! creates user, server and makes http call to server" do
      registration = Registration.new(
        email: "admin@fedi.example.com",
        base_url: "https://fedi.example.com/fasp",
        password: "super_secret",
        password_confirmation: "super_secret"
      )

      assert_difference [ -> { User.count }, -> { Server.count } ], 1 do
        registration.save!
      end

      assert_requested :post, "https://fedi.example.com/fasp/registration"

      new_server = Server.last

      assert_equal "dfkl3msw6ps3", new_server.fasp_remote_id
      assert_equal "https://fedi.example.com/admin/fasps", new_server.registration_completion_uri
    end
  end
end
