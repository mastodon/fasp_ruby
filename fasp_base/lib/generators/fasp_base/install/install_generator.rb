class FaspBase::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def install
    rails_command "fasp_base:install:migrations"
    rails_command "db:migrate"

    route 'root "fasp_base/homes#show"'
    route 'mount FaspBase::Engine, at: "/"'

    copy_file "initializers/fasp_base.rb", "config/initializers/fasp_base.rb"
    copy_file "config/tailwind.config.js", "config/tailwind.config.js"
    copy_file "layouts/application.html.erb", "app/views/layouts/application.html.erb"
    copy_file "layouts/admin.html.erb", "app/views/layouts/admin.html.erb"
    copy_file "tailwind/application.css", "app/assets/tailwind/application.css"

    inject_into_class "app/controllers/application_controller.rb", "ApplicationController" do
      "  include FaspBase::Authentication\n\n"
    end
    inject_into_module "app/helpers/application_helper.rb", "ApplicationHelper" do
      "  include FaspBase::ApplicationHelper\n\n"
    end
  end
end
