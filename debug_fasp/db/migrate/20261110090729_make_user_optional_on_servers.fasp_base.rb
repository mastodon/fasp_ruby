# This migration comes from fasp_base (originally 20261016135108)
class MakeUserOptionalOnServers < ActiveRecord::Migration[8.1]
  def change
    change_column :fasp_base_servers, :user_id, :integer, null: true
  end
end
