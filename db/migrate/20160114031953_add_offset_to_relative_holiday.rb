class AddOffsetToRelativeHoliday < ActiveRecord::Migration
  def change
    add_column :relative_holidays, :offset, :integer, default: 0
  end
end
