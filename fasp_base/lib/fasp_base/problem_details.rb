module FaspBase
  class ProblemDetails
    def initialize(model) = @model = model

    def to_json(options = nil)
      {
        type: "https://fasp.dev/ns#validation-error",
        errors:
      }
    end

    private

    def errors
      @model.errors.map do |error|
        {
          detail: error.full_message,
          pointer: "/#{error.attribute.to_s.camelize(:lower)}"
        }
      end
    end
  end
end
