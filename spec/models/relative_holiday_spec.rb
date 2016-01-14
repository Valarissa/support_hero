require 'rails_helper'

RSpec.describe RelativeHoliday, type: :model do
  describe "::check" do
    before do
      described_class.create(month: 5, day_of_week: 1, occurrence: "last", name: "Memorial Day")
      described_class.create(month: 11, day_of_week: 4, occurrence: "fourth", name: "Thanksgiving Day")
      described_class.create(month: 11, day_of_week: 4, occurrence: "fourth", offset: 1, name: "Thanksgiving Friday")
    end

    it "properly calculates that a date is not a defined RecurringHoliday" do
      non_holidays = [
        Date.new(2016, 1, 5),
        Date.new(2016, 2, 17),
        Date.new(2016, 10, 11)
      ]
      non_holidays.each do |date|
        expect(described_class.check(date)).to eq(false)
      end
    end

    it "properly calculates that a date is a defined RecurringHoliday" do
      holidays = [
        Date.new(2015, 5, 25),
        Date.new(2016, 5, 30),
        Date.new(2016, 11, 24)
      ]

      holidays.each do |date|
        expect(described_class.check(date)).to eq(true)
      end
    end

    it "properly calculates that a date is a RecurringHoliday with an offset" do
      offset_holidays = [
        Date.new(2015, 11, 27),
        Date.new(2016, 11, 25)
      ]

      offset_holidays.each do |date|
        expect(described_class.check(date)).to eq(true)
      end
    end
  end
end
