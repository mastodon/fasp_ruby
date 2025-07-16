module FaspBase
  module Linzer
    module Adapter
      module ActionDispatch
        class Response < ::Linzer::Message::Adapter::Generic::Response
          private
          # Incomplete, but sufficient for FASP
          def derived(name)
            @operation.status if name.value == "@status"
          end
        end
      end
    end
  end
end

Linzer::Message.register_adapter(ActionDispatch::Response, FaspBase::Linzer::Adapter::ActionDispatch::Response)
