class RelativeHoliday < ActiveRecord::Base
  validates :occurrence, inclusion: { in: %w(first second third fourth last) }
  validates :day_of_week, inclusion: { in: (0..6) }
  validates :month, inclusion: { in: (1..12) }

  class << self
    def check(date)
      holidays = RelativeHoliday.where(month: date.month, day_of_week: date.wday, offset: 0)
      holidays.each do |holiday|
        return true if date == holiday.for_year(date.year)
      end
      relative_to_relative = RelativeHoliday.where(month: date.month).where.not(offset: 0)
      relative_to_relative.each do |holiday|
        return true if date == holiday.for_year(date.year)
      end

      false
    end
  end

  def for_year(year)
    send("#{occurrence}_given_day_of_month", year)
  end

  def first_given_day_of_month(year)
    date = Date.new(year, self.month)
    weekday_of_first_day = date.wday
    modifier = if self.day_of_week == weekday_of_first_day
                 0
               elsif self.day_of_week > weekday_of_first_day
                 self.day_of_week - weekday_of_first_day
               else
                 (7 - weekday_of_first_day) + self.day_of_week
               end
    date + modifier.days + offset.days
  end

  def second_given_day_of_month(year)
    first_given_day_of_month(year) + 1.week
  end

  def third_given_day_of_month(year)
    first_given_day_of_month(year) + 2.weeks
  end

  def fourth_given_day_of_month(year)
    first_given_day_of_month(year) + 3.weeks
  end

  def last_given_day_of_month(year)
    date = fourth_given_day_of_month(year)
    if (date + 1.week).month == self.month
      date + 1.week
    else
      date
    end
  end
end
