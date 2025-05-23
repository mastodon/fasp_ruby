module FaspBase
  module Linzer
    module Adapter
      module HTTPX
        class Request < ::Linzer::Message::Adapter::Abstract
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
            case name.value
            when :method           then @operation.verb
            when :"target-uri"     then @operation.uri.to_s
            when :authority        then @operation.authority
            when :scheme           then @operation.scheme
            when :"request-target" then @operation.uri.request_uri
            when :path             then @operation.path
            when :query            then "?%s" % String(@operation.query)
            when :"query-param"    then query_param(name)
            end
          end

          def query_param(name)
            param_name = name.parameters["name"]
            return nil if !param_name
            decoded_param_name = URI.decode_uri_component(param_name)
            params = CGI.parse(@operation.query)
            URI.encode_uri_component(params[decoded_param_name]&.first)
          end

          def field(name)
            has_tr = name.parameters["tr"]
            return nil if has_tr # HTTP requests don't have trailer fields
            value = @operation.headers[name.value.to_s]
            value.dup&.strip
          end
        end
      end
    end
  end
end

Linzer::Message.register_adapter(HTTPX::Request, FaspBase::Linzer::Adapter::HTTPX::Request)
