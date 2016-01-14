require 'rails_helper'

RSpec.describe Day, type: :model do
  it "cannot represent a Holiday" do
    ExactHoliday.create(month: 3, day: 31, name: "Cesar Chavez Day").save
    expect(described_class.create(date: Date.new(2016,3,31)).valid?).to eq(false)
  end

  it "cannot represent a weekend" do
    expect(described_class.create(date: Date.new(2016,1,16)).valid?).to eq(false)
    expect(described_class.create(date: Date.new(2016,1,17)).valid?).to eq(false)
  end

  describe "#swap" do
    let(:tom){ Hero.create(name: "Tom") }
    let(:beth){ Hero.create(name: "Beth") }
    before do
      tom.days.create(date: Date.new(2016,1,13))
      beth.days.create(date: Date.new(2016,1,14))
    end

    it "swaps the owner of two days" do
      tom.days.first.swap(beth.days.first)
      tom.reload
      beth.reload
      expect(tom.days.first.date).to eq(Date.new(2016,1,14))
      expect(beth.days.first.date).to eq(Date.new(2016,1,13))
    end
  end

  describe "::surrounding_range" do
    it "finds days within a number of calendar days" do
      days_in_range = [
        described_class.create(date: Date.new(2016,1,19)),
        described_class.create(date: Date.new(2016,1,12))
      ]
      days_out_of_range = [
        described_class.create(date: Date.new(2016,2,1)),
        described_class.create(date: Date.new(2015,12,13))
      ]
      date = Date.new(2016,1,14)
      expect(described_class.surrounding_range(date, 7)).to include(*days_in_range)
      expect(described_class.surrounding_range(date, 7)).not_to include(*days_out_of_range)
    end
  end

  describe "#find_and_swap" do
    let(:tom) { Hero.create(name: "Tom") }
    let(:beth) { Hero.create(name: "Beth") }
    let(:rachel) { Hero.create(name: "Rachel") }
    let(:subject) { tom.days.create(date: Date.new(2016,1,14)) }

    before do
      ##
      # Freeze these tests in time
      Date.stub(:today => Date.new(2016,1,10))
    end

    it "finds a day owned by a different hero than the day's hero and swaps them" do
      tom.undoable_days.create(date: subject.date)
      beth.undoable_days.create(date: subject.date)
      no_swap_day = beth.days.create(date: Date.new(2016,1,13))
      swap_day = rachel.days.create(date: Date.new(2016,1,15))

      expect(subject.find_and_swap).to eq(swap_day)
      expect(swap_day.reload.hero).to eq(tom)
      expect(subject.reload.hero).to eq(rachel)
    end

    ##
    # "I need a hero~! I'm holding out for a hero 'til the end of the night~!"
    # Sorry...
    it "raises an error if no hero can be found" do
      tom.undoable_days.create(date: subject.date)
      beth.undoable_days.create(date: subject.date)
      rachel.undoable_days.create(date: subject.date)
      no_swap_day = beth.days.create(date: Date.new(2016,1,13))
      also_no_swap_day = rachel.days.create(date: Date.new(2016,1,15))

      expect{subject.find_and_swap}.to raise_error(Day::UnreconciledDayError)
    end
  end
end
