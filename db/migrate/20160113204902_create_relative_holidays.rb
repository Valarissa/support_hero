class CreateRelativeHolidays < ActiveRecord::Migration
  def change
    create_table :relative_holidays do |t|
      t.integer :day_of_week
      t.integer :month
      t.string :occurrence
      t.string :name

      t.timestamps null: false
    end
  end
end
