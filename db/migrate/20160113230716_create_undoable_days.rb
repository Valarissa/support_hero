class CreateUndoableDays < ActiveRecord::Migration
  def change
    create_table :undoable_days do |t|
      t.date :date
      t.references :hero, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :undoable_days, [:hero_id, :date], unique: true
  end
end
