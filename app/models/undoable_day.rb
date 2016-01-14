class UndoableDay < ActiveRecord::Base
  belongs_to :hero
  belongs_to :day
end
