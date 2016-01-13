class ExactHoliday < ActiveRecord::Base
  validate :valid_date?

  class << self
    def check(date)
      exists?(month: date.month, day: date.day)
    end
  end

  def valid_date?
    return true if (month == 2 && day == 29) # Leap Year acceptance
    Date.new(Date.today.year, month, day)
  rescue ArgumentError => e
    if e.message == "invalid date"
      if month < 1 || month > 12
        errors.add(:month, "invalid month")
      else
        errors.add(:day, "invalid day, or invalid day for month")
      end
    else
      raise e
    end
  end
end
