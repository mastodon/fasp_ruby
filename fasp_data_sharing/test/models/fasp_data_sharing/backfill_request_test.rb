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
  end
end
