module FaspBase
  module Linzer
    module Adapter
      module HTTPX
        class Response < ::Linzer::Message::Adapter::Abstract
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

          def [](field_name)
            return @operation.status if field_name == "@status"
            @operation.headers[field_name]
          end
        end
      end
    end
  end
end

Linzer::Message.register_adapter(HTTPX::Response, FaspBase::Linzer::Adapter::HTTPX::Response)
