class FaspDataSharing::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def install
    rails_command "fasp_data_sharing:install:migrations"
    rails_command "db:migrate"

    route 'mount FaspDataSharing::Engine, at: "/"'
  end
end
