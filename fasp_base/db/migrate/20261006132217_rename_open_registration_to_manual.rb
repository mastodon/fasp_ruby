class RenameOpenRegistrationToManual < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE fasp_base_settings SET value = 'manual' WHERE name = 'registration' AND value = 'open'"
  end

  def down
    execute "UPDATE fasp_base_settings SET value = 'open' WHERE name = 'registration' AND value = 'manual'"
  end
end
