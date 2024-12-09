ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "webmock"
require "httpx/adapters/webmock"
require "webmock/minitest"
WebMock.disable_net_connect!(
  allow_localhost: true
)

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    self.fixture_paths << FaspBase::Engine.root.join("test/fixtures")
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
