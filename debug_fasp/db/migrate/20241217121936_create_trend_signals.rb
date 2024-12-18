class CreateTrendSignals < ActiveRecord::Migration[8.0]
  def change
    create_table :trend_signals do |t|
      t.references :content, null: false, foreign_key: true

      t.timestamps
    end
  end
end
