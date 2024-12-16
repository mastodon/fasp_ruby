require "test_helper"

module FaspDataSharing
  class ActorTest < ActiveSupport::TestCase
    test "first call of ::instance will generate a new actor, subsequent call return the existing record" do
      actor = nil
      Actor.remove_instance_variable(:@instance) if Actor.instance_variable_defined?(:@instance)

      assert_difference -> { Actor.count }, 1 do
        actor = Actor.instance
      end

      assert_equal actor, Actor.instance
    end
  end
end
