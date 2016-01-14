class Hero < ActiveRecord::Base
  has_many :days
  has_many :undoable_days, dependent: :destroy

  def undoable(day)
    self.undoable_days.create(day: day)
    day.find_and_swap
  end
end
