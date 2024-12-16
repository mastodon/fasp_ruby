require_relative "lib/fasp_data_sharing/version"

Gem::Specification.new do |spec|
  spec.name        = "fasp_data_sharing"
  spec.version     = FaspDataSharing::VERSION
  spec.authors     = [ "David Roetzel" ]
  spec.email       = [ "david@roetzel.de" ]
  spec.homepage    = "https://github.com/mastodon/fasp_ruby"
  spec.summary     = "Data sharing facilities for discovery FASPs"
  spec.description = "A rails enginge implementing data sharing facilities for Fediverse Auxiliary Services Providers"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.0"
  spec.add_dependency "fasp_base"

  spec.add_development_dependency "webmock"
end
