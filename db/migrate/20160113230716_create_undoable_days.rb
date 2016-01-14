class CreateUndoableDays < ActiveRecord::Migration
  def change
    create_table :undoable_days do |t|
      t.references :day, index: true, foreign_key: true
      t.references :hero, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :undoable_days, [:hero_id, :day_id], unique: true
  end
end
