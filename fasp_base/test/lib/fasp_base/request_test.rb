require "test_helper"

module FaspBase
  class FaspBase::RequestTest < ActiveSupport::TestCase
    test "prevents request to local IP" do
      server = Server.create!(
        user: fasp_base_users(:mastodon_admin),
        base_url: "https://198.51.100.23/api/fasp",
        fasp_remote_id: "somefasp1962"
      )
      request = Request.new(server)

      assert_raises HTTPX::ServerSideRequestForgeryError do
        request.get("/")
      end
    end
  end
end
