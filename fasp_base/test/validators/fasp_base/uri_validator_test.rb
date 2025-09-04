require "test_helper"

module FaspBase
  class UriValidatorTest < ::ActiveSupport::TestCase
    class Website
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :uri, :string

      validates :uri, 'fasp_base/uri': true
    end

    setup do
      @website = Website.new
    end

    test "non-https URIs are invalid" do
      invalid_uris = %w[ ftp://example.com file:///root/ ]

      invalid_uris.each do |uri|
        @website.uri = uri

        assert @website.invalid?
      end
    end

    test "missing, incomplete or syntactically wrong URIs are invalid" do
      invalid_uris = [ nil, "", "abc", "www.test.com", "https///test" ]

      invalid_uris.each do |uri|
        @website.uri = uri

        assert @website.invalid?
      end
    end

    test "URI with hostnames resolving to private IPs are invalid" do
      local_uris = %w[ http://127.0.0.1/test https://127.0.0.123/other http://localhost:3000/base ]

      local_uris.each do |uri|
        @website.uri = uri

        assert @website.invalid?
      end
    end

    test "external, existing URI is valid" do
      @website.uri = "https://github.com/mastodon"

      assert @website.valid?
    end
  end
end
