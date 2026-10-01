require "bcrypt"
require "httpx"
require "linzer"

module FaspBase
  class Engine < ::Rails::Engine
    isolate_namespace FaspBase

    initializer "fasp_base.linzer_adapters" do
      require "linzer/rack"

      ::Linzer::Message.register_adapter(ActionDispatch::Response, FaspBase::Linzer::Adapter::ActionDispatch::Response)
      ::Linzer::Message.register_adapter(HTTPX::Request, FaspBase::Linzer::Adapter::HTTPX::Request)
      ::Linzer::Message.register_adapter(HTTPX::Response, FaspBase::Linzer::Adapter::HTTPX::Response)
    end

    # Require `Request` late in the boot process
    # to enable users to install httpx's webmock
    # integration before httpx is initialized.
    initializer "fasp_base.require_request" do
      require "fasp_base/request"
    end
  end
end
