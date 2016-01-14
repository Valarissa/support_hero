class Day < ActiveRecord::Base
  ERROR_THRESHOLD = 365
  class UnreconciledDayError < ArgumentError; end

  validate :is_not_holiday?
  validate :is_not_weekend?
  belongs_to :hero
  has_many :undoable_days

  default_scope { order(:date) }

  class << self
    def after_today
      where('date > ?', Date.today)
    end

    def surrounding_range(date, count_of_days)
      where(date: ((date - count_of_days.days)..(date + count_of_days.days)))
    end

    def next_valid(date:)
      while(!new(date: date).valid?)
        date = date + 1.day
      end
      find_or_create_by(date: date)
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
  def progressive_find
    swap = false
    range = 7
    while(!swap)
      check_excess_range(range)
      available_days = swappable_days(range)
      if available_days.count > 0
        return available_days
      end
      range *= 2
    end
  end

  def swappable_days(range=nil)
    @restricted_users ||= undoable_days.pluck(:hero_id)
    available_days = self.class
                         .after_today
                         .where.not(hero_id: @restricted_users)
                         .where.not(hero_id: hero_id)
    available_days = available_days.surrounding_range(date, range) if range
    available_days.all
  end

  def find_and_swap
    closest_available_days = progressive_find
    swap(closest_available_days.shuffle.first)
  end

  def next_valid
    self.class.next_valid(date: (date + 1.day))
  end

  private

  def check_excess_range(range)
    if range > ERROR_THRESHOLD
      raise UnreconciledDayError, "Cannot find a hero D:"
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
