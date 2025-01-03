require "test_helper"

class AnnouncementsTest < ActionDispatch::IntegrationTest
  include FaspBase::IntegrationTestHelper

  setup do
    @server = fasp_base_servers(:fedi_server)
  end

  test "without matching subscription it enqueues no jobs" do
    payload = {
      source: {
        subscription: {
          id: "58152"
        }
      },
      category: "content",
      eventType: "new",
      objectUris: [
        "https://fediverse-server.example.com/@example/2342",
        "https://fediverse-server.example.com/@other/8726"
      ]
    }
    uri = fasp_data_sharing.fasp_data_sharing_v0_announcements_url
    headers = request_authentication_headers(@server, :post, uri, payload)

    assert_no_enqueued_jobs do
      post fasp_data_sharing.fasp_data_sharing_v0_announcements_path, as: :json, params: payload, headers: headers
    end

    assert_response :success
  end

  test "with a matching lifecycle subscription it enqueues jobs" do
    subscription = fasp_data_sharing_subscriptions(:content_lifecycle)
    payload = {
      source: {
        subscription: {
          id: subscription.remote_id
        }
      },
      category: "content",
      eventType: "new",
      objectUris: [
        "https://fediverse-server.example.com/@example/2342",
        "https://fediverse-server.example.com/@other/8726"
      ]
    }
    uri = fasp_data_sharing.fasp_data_sharing_v0_announcements_url
    headers = request_authentication_headers(@server, :post, uri, payload)

    assert_enqueued_jobs 2, only: FaspDataSharing::ProcessNewContentJob do
      post fasp_data_sharing.fasp_data_sharing_v0_announcements_path, as: :json, params: payload, headers: headers
    end

    assert_response :success
  end

  test "with a matching trends subscription it enqueues jobs" do
    subscription = fasp_data_sharing_subscriptions(:content_trends)
    payload = {
      source: {
        subscription: {
          id: subscription.remote_id
        }
      },
      category: "content",
      eventType: "trending",
      objectUris: [
        "https://fediverse-server.example.com/@example/2342",
        "https://fediverse-server.example.com/@other/8726"
      ]
    }
    uri = fasp_data_sharing.fasp_data_sharing_v0_announcements_url
    headers = request_authentication_headers(@server, :post, uri, payload)

    assert_enqueued_jobs 2, only: FaspDataSharing::ProcessTrendingContentJob do
      post fasp_data_sharing.fasp_data_sharing_v0_announcements_path, as: :json, params: payload, headers: headers
    end

    assert_response :success
  end

  test "with a matching backfill request it enqueues jobs" do
    backfill_request = fasp_data_sharing_backfill_requests(:accounts)
    payload = {
      source: {
        backfillRequest: {
          id: backfill_request.remote_id
        }
      },
      category: "account",
      moreObjectsAvailable: true,
      objectUris: [
        "https://fediverse-server.example.com/@example/2342",
        "https://fediverse-server.example.com/@other/8726"
      ]
    }
    uri = fasp_data_sharing.fasp_data_sharing_v0_announcements_url
    headers = request_authentication_headers(@server, :post, uri, payload)

    assert_enqueued_jobs 2, only: FaspDataSharing::ProcessAccountBackfillJob do
      post fasp_data_sharing.fasp_data_sharing_v0_announcements_path, as: :json, params: payload, headers: headers
    end

    assert_response :success
  end


  test "with a matching backfill request and no more objects to get it marks the backfill request as fulfilled" do
    backfill_request = fasp_data_sharing_backfill_requests(:accounts)
    payload = {
      source: {
        backfillRequest: {
          id: backfill_request.remote_id
        }
      },
      category: "account",
      moreObjectsAvailable: false,
      objectUris: [
        "https://fediverse-server.example.com/@example/2342",
        "https://fediverse-server.example.com/@other/8726"
      ]
    }

    uri = fasp_data_sharing.fasp_data_sharing_v0_announcements_url
    headers = request_authentication_headers(@server, :post, uri, payload)

    assert_changes -> { backfill_request.fulfilled? } do
      assert_enqueued_jobs 2, only: FaspDataSharing::ProcessAccountBackfillJob do
        post fasp_data_sharing.fasp_data_sharing_v0_announcements_path, as: :json, params: payload, headers: headers

        backfill_request.reload
      end
    end

    assert_response :success
  end
end
