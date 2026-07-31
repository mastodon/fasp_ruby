require "bcrypt"
require "httpx"
require "linzer"

module FaspBase
  class Engine < ::Rails::Engine
    isolate_namespace FaspBase

    # Require `Request` late in the boot process
    # to enable users to install httpx's webmock
    # integration before httpx is initialized.
    initializer "fasp_base.require_request" do
      require "fasp_base/request"
    end
  end
end
