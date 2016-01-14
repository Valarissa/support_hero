module ScheduleCreator
  def self.reset_to_defaults(starting_date: Date.today)
    scrub_schedule
    set_ca_holidays

    starting_list = [
      "Sherry", "Boris", "Vicente", "Matte", "Jack", "Sherry",
      "Matte", "Kevin", "Kevin", "Vicente", "Zoe", "Kevin",
      "Matte", "Zoe", "Jay", "Boris", "Eadon", "Sherry",
      "Franky", "Sherry", "Matte", "Franky", "Franky", "Kevin",
      "Boris", "Franky", "Vicente", "Luis", "Eadon", "Boris",
      "Kevin", "Matte", "Jay", "James", "Kevin", "Sherry",
      "Sherry", "Jack", "Sherry", "Jack"
    ]

    create(list: starting_list, starting_on: starting_date)
  end

  def self.create(list:, starting_on: Date.today)
    date = starting_on
    date = Date.new(date) unless date.is_a?(Date) # Not my favorite...
    day = Day.next_valid(date: date)
    list.each do |name|
      hero = Hero.find_or_create_by(name: name)
      day.hero = hero
      day.save
      day = day.next_valid
    end
    day.destroy # Remove day without a hero
  end

  def self.scrub_schedule
    Day.destroy_all
    Hero.destroy_all
    ExactHoliday.destroy_all
    RelativeHoliday.destroy_all
  end

  def self.set_ca_holidays
    ExactHoliday.create(month: 1, day: 1, name: "New Year's Day")
    RelativeHoliday.create(month: 1, day_of_week: 1, occurrence: "third", name: "Martin Luther King, Jr. Day")
    ExactHoliday.create(month: 2, day: 1, name: "Rosa Parks Day")
    RelativeHoliday.create(month: 2, day_of_week: 1, occurrence: "third", name: "President's Day")
    ExactHoliday.create(month: 3, day: 31, name: "Cesar Chavez Day")
    RelativeHoliday.create(month: 5, day_of_week: 1, occurrence: "last", name: "Memorial Day")
    ExactHoliday.create(month: 7, day: 4, name: "Independence Day")
    RelativeHoliday.create(month: 9, day_of_week: 1, occurrence: "first", name: "Labor Day")
    RelativeHoliday.create(month: 9, day_of_week: 5, occurrence: "fourth", name: "Native American Day")
    ExactHoliday.create(month: 11, day: 11, name: "Veterans' Day")
    RelativeHoliday.create(month: 11, day_of_week: 4, occurrence: "fourth", name: "Thanksgiving Day")
    RelativeHoliday.create(month: 11, day_of_week: 4, occurrence: "fourth", name: "Thanksgiving Friday", offset: 1)
    ExactHoliday.create(month: 12, day: 25, name: "Christmas Day")
  end
end
