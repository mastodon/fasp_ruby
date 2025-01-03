require "test_helper"

module FaspDataSharing
  class BackfillRequestTest < ActiveSupport::TestCase
    include FaspBase::IntegrationTestHelper

    setup do
      @server = fasp_base_servers(:fedi_server)
      stub_request_to(@server, :post, "/data_sharing/v0/backfill_requests", 201,
        {
          backfillRequest: {
            id: "672"
          }
        }
      )
    end

    test "creating a content backfill request" do
      backfill_request = BackfillRequest.make(@server, category: "content", max_count: 25)

      assert_equal "672", backfill_request.remote_id
      assert_equal @server, backfill_request.fasp_base_server
      assert_equal "content", backfill_request.category
      assert_equal 25, backfill_request.max_count
    end

    test "creating an accounts backfill request" do
      backfill_request = BackfillRequest.make(@server, category: "account", max_count: 90)

      assert_equal "672", backfill_request.remote_id
      assert_equal @server, backfill_request.fasp_base_server
      assert_equal "account", backfill_request.category
      assert_equal 90, backfill_request.max_count
    end

    test "continuing an existing backfill request" do
      stubbed_request = stub_request_to(@server, :post, "/data_sharing/v0/backfill_requests/672/continuation", 204)
      backfill_request = BackfillRequest.create(
        fasp_base_server: @server,
        remote_id: "672",
        category: "content",
        max_count: 100
      )
      backfill_request.continue!

      assert_requested(stubbed_request)
    end

    test "marking as fulfilled" do
      backfill_request = BackfillRequest.create(
        fasp_base_server: @server,
        remote_id: "672",
        category: "content",
        max_count: 100
      )

      assert_changes -> { backfill_request.fulfilled? } do
        backfill_request.mark_as_fulfilled!
      end
    end
  end
end
