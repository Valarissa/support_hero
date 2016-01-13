require 'rails_helper'

RSpec.describe ExactHoliday, type: :model do
  ##
  # Testing this validation as it is custom and therefore not tested by Rails
  #
  it "ensures the month and day combination is valid" do
    expect(described_class.new(month: 13, day: 22, name: "Fakestag").valid?).to eq(false)
    expect(described_class.new(month: 2, day: 29, name: "Leap Day").valid?).to eq(true)
    expect(described_class.new(month: 4, day: 31, name: "April Double Foolies").valid?).to eq(false)
  end

  describe "::check" do
    before do
      described_class.create(month: 7, day: 4, name: "Independence Day")
      described_class.create(month: 10, day: 31, name: "Halloween")
    end

    it "properly calculates that a date is not a defined ExactHoliday" do
      non_holidays = [
        Date.new(2016, 1, 5),
        Date.new(2016, 2, 17),
        Date.new(2016, 10, 11)
      ]
      non_holidays.each do |date|
        expect(described_class.check(date)).to eq(false)
      end
    end

    it "properly calculates that a date is a defined ExactHoliday" do
      holidays = [
        Date.new(2015, 7, 4),
        Date.new(2016, 7, 4),
        Date.new(2016, 10, 31)
      ]

      holidays.each do |date|
        expect(described_class.check(date)).to eq(true)
      end
    end
  end
end
