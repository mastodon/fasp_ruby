require "bcrypt"
require "httpx"
require "linzer"

module FaspBase
  class Engine < ::Rails::Engine
    isolate_namespace FaspBase
  end
end
