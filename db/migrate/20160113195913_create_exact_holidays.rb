class CreateExactHolidays < ActiveRecord::Migration
  def change
    create_table :exact_holidays do |t|
      t.integer :month
      t.integer :day
      t.string :name

      t.timestamps null: false
    end
  end
end
