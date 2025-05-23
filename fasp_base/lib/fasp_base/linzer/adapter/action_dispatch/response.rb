module FaspBase
  module Linzer
    module Adapter
      module ActionDispatch
        class Response < ::Linzer::Message::Adapter::Abstract
          def initialize(operation, **_options) # rubocop:disable Lint/MissingSuper
            @operation = operation
          end

          def header(name)
            @operation.headers[name]
          end

          def attach!(signature)
            signature.to_h.each { |h, v| @operation.headers[h] = v }
          end

          # Incomplete, but sufficient for FASP
          def [](field_name)
            return @operation.status if field_name == '@status'

            @operation.headers[field_name]
          end
        end
      end
    end
  end
end

Linzer::Message.register_adapter(ActionDispatch::Response, FaspBase::Linzer::Adapter::ActionDispatch::Response)
