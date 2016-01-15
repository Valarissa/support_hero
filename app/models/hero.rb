class Hero < ActiveRecord::Base
  has_many :days
  has_many :undoable_days, dependent: :destroy

  def undoable(day)
    day.find_and_swap
    self.undoable_days.create(day: day)
  end
end
