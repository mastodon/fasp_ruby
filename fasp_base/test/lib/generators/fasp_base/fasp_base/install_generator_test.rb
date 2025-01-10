require "test_helper"
require "generators/fasp_base/install/install_generator"

module FaspBase
  class FaspBase::InstallGeneratorTest < Rails::Generators::TestCase
    tests FaspBase::InstallGenerator
    destination Rails.root.join("tmp/generators")
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
