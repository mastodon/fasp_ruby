require "test_helper"

module FaspBase
  class ProblemDetailsTest < ActiveSupport::TestCase
    class Model
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name, :string
      attribute :email_address, :string

      validates :name, presence: true
      validates :email_address, format: /@/
    end

    test "#to_json returns custom RFC9457 format" do
      invalid_model = Model.new(email_address: "test")
      assert invalid_model.invalid?

      expected_json = {
        type: "https://fasp.dev/ns#validation-error",
        errors: [
          {
            detail: "Name can't be blank",
            pointer: "/name"
          },
          {
            detail: "Email address is invalid",
            pointer: "/emailAddress"
          }
        ]
      }

      problem_details = ProblemDetails.new(invalid_model)
      assert_equal expected_json, problem_details.to_json
    end
  end
end
