require "test_helper"

module FaspBase
  class ServerTest < ActiveSupport::TestCase
    setup do
      @server = fasp_base_servers(:mastodon_server)
      FaspBase.capabilities = [
        { id: "test", version: "2.1" }
      ]
    end

    teardown do
      FaspBase.capabilities = []
    end

    test "#enable_capability! enables a capability" do
      assert_not @server.capability_enabled?("test", version: 2)
      @server.enable_capability!("test", version: 2)

      assert @server.capability_enabled?("test", version: 2)
    end

    test "#enable_capability! raises if a capability is unknown/unsupported" do
      assert_raises ArgumentError do
        @server.enable_capability!("unknown", version: 4)
      end
    end

    test "#disable_capability! disables a capability that was previously enabled" do
      @server.enable_capability!("test", version: 2)
      assert @server.capability_enabled?("test", version: 2)
      @server.disable_capability!("test", version: 2)

      assert_not @server.capability_enabled?("test", version: "2")
    end
  end
end
