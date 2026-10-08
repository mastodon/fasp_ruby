Rails.application.routes.draw do
  mount FaspBase::Engine => "/"

    root to: proc { [ 200, { "Content-Type" => "text/plain" }, [ "Root path to dummy host app" ] ] }
end
