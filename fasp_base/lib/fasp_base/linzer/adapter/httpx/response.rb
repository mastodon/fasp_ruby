module FaspBase
  module Linzer
    module Adapter
      module HTTPX
        class Response < ::Linzer::Message::Adapter::Generic::Response
          def initialize(operation, **options)
            @operation = operation
          end

          def header(name)
            @operation.headers[name]
          end

          def attach!(signature)
            signature.to_h.each { |h, v| @operation.headers[h] = v }
            @operation
          end

          private

          def derived(name)
            @operation.status if name.value == "@status"
          end

          def field(name)
            has_tr = name.parameters["tr"]
            return nil if has_tr

            value = @operation.headers[name.value.to_s]
            value.dup&.strip
          end
        end
      end
    end
  end
end

Linzer::Message.register_adapter(HTTPX::Response, FaspBase::Linzer::Adapter::HTTPX::Response)
