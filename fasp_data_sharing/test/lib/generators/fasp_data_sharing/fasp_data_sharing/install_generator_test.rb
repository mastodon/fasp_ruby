require "test_helper"
require "generators/fasp_data_sharing/install/install_generator"

module FaspDataSharing
  class FaspDataSharing::InstallGeneratorTest < Rails::Generators::TestCase
    tests FaspDataSharing::InstallGenerator
    destination Rails.root.join("tmp/generators")
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
