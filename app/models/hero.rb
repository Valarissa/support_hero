class Hero < ActiveRecord::Base
  has_many :days
  has_many :undoable_days

  def undoable(day)
    self.undoable_days.create(date: day.date)
    day.find_and_swap
  end
end
