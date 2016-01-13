class Day < ActiveRecord::Base
  validate :is_not_holiday?
  validate :is_not_weekend?
  belongs_to :hero

  def is_holiday?
    ExactHoliday.check(date) ||
      RelativeHoliday.check(date)
  end

  def is_weekend?
    [0,6].include?(date.wday)
  end

  def is_not_holiday?
    if is_holiday?
      errors.add(:date, "day is a holiday")
    end
  end

  def is_not_weekend?
    if is_weekend?
      errors.add(:date, "day is weekend")
    end
  end
end
