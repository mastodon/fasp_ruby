class CreateLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :logs do |t|
      t.references :fasp_base_server, null: false, foreign_key: true
      t.string :ip
      t.text :request_body

      t.timestamps
    end
  end
end
