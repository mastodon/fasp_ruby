require_relative "lib/fasp_base/version"

Gem::Specification.new do |spec|
  spec.name        = "fasp_base"
  spec.version     = FaspBase::VERSION
  spec.authors     = [ "David Roetzel" ]
  spec.email       = [ "david@roetzel.de" ]
  spec.homepage    = "https://github.com/mastodon/fasp_ruby/fasp_base"
  spec.summary     = "Basic building blocks for a rails-based FASP"
  spec.description = "A rails engine that includes the basic building blocks to develop a Fediverse Auxiliary Services Provider"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.0"
  spec.add_dependency "bcrypt"
  spec.add_dependency "httpx"
  spec.add_dependency "linzer"
  spec.add_dependency "openssl"

  spec.add_development_dependency "webmock"
end
