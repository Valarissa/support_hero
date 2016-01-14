class Day < ActiveRecord::Base
  ERROR_THRESHOLD = 365
  validate :is_not_holiday?
  validate :is_not_weekend?
  belongs_to :hero

  class << self
    def after_today
      where('date > ?', Date.today)
    end

    def surrounding_range(date, count_of_days)
      where(date: ((date - count_of_days.days)..(date + count_of_days.days)))
    end
  end

  def swap(day)
    hero = self.hero
    self.hero = day.hero
    day.hero = hero

    day.save
    save

    day
  end

  ##
  # This is a fairly simplistic algorithm, it is quite possible to lock
  # such an algorithm outside of the explored range (the 40 days given)
  #
  # Multi-person algorithms are definitely possible but could be an
  # entire discussion in and of themselves.
  def find_and_swap
    restricted_users = UndoableDay.where(date: date).pluck(:hero_id)
    swap = false
    range = 7
    while(!swap)
      check_excess_range(range)
      available_days = self.class
                           .surrounding_range(date, range)
                           .after_today
                           .where('hero_id NOT IN (?)', restricted_users)
                           .all
      if available_days.count > 0
        swap = swap(available_days.shuffle.first)
      end
      range *= 2
    end

    swap
  end

  def check_excess_range(range)
    if range > ERROR_THRESHOLD
      raise "Cannot find a hero D:"
    end
  end

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
