class CreateFaspBaseActors < ActiveRecord::Migration[8.1]
  def change
    create_table :fasp_base_actors do |t|
      t.string :private_key_pem, null: false

      t.timestamps
    end
  end
end
