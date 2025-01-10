include_data_sharing = yes?("Include data sharing engine?")

gem "fasp_base", git: "git@github.com:mastodon/fasp_ruby", glob: "fasp_base/*.gemspec"

gem "fasp_data_sharing", git: "git@github.com:mastodon/fasp_ruby", glob: "fasp_data_sharing/*.gemspec" if include_data_sharing

after_bundle do
  generate "fasp_base:install"

  generate "fasp_data_sharing:install" if include_data_sharing
end
