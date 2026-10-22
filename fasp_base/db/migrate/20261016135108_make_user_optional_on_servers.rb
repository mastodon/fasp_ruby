class MakeUserOptionalOnServers < ActiveRecord::Migration[8.1]
  def change
    change_column :fasp_base_servers, :user_id, :integer, null: true
  end
end
