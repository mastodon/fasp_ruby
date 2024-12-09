require_relative "lib/fasp_base/version"

Gem::Specification.new do |spec|
  spec.name        = "fasp_base"
  spec.version     = FaspBase::VERSION
  spec.authors     = [ "David Roetzel" ]
  spec.email       = [ "david@roetzel.de" ]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of FaspBase."
  spec.description = "TODO: Description of FaspBase."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

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
