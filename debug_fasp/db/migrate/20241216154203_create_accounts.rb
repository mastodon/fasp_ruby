class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :uri, null: false, index: { unique: true }
      t.string :object_type, null: false
      t.json :full_object, null: false

      t.timestamps
    end
  end
end
