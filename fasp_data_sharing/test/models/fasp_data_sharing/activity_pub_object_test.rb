require "test_helper"

module FaspDataSharing
  class ActivityPubObjectTest < ActiveSupport::TestCase
    setup do
      @uri = "http://fedi.example.com/objects/4223"
      @json_object = {
        "@context" => "https://www.w3.org/ns/activitystreams",
        "id" => @uri
      }
      @activity_pub_object = ActivityPubObject.new(uri: @uri)
    end

    test "when server supports HTTP Message Signatures fetching works on the first try" do
      message_signatures_stub = stub_request(:get, @uri)
        .with { |r| r.headers["Signature-Input"].present? }
        .to_return_json(
          body: @json_object,
          headers: { "content-type" => "application/activity+json"
        })

      returned_json = @activity_pub_object.fetch

      assert_equal @json_object, returned_json
      assert_requested(message_signatures_stub)
    end

    test "when server supports HTTP signatures fetching works on the second try" do
      message_signatures_stub = stub_request(:get, @uri)
        .with { |r| r.headers["Signature-Input"] }
        .to_return(status: 401)

      signatures_stub = stub_request(:get, @uri)
        .to_return_json(
          body: @json_object,
          headers: { "content-type" => "application/activity+json"
        })

      returned_json = @activity_pub_object.fetch

      assert_equal @json_object, returned_json
      assert_requested(message_signatures_stub)
      assert_requested(signatures_stub)
    end
  end
end
