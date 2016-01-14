require 'rails_helper'

RSpec.describe Hero, type: :model do
  describe "#undoable" do
    let(:subject) { described_class.create(name: "Tom") }
    let(:beth) { described_class.create(name: "Beth") }

    before do
      Date.stub(today: Date.new(2016, 1, 10)) #Set this test in time
      subject.days.create(date: Date.new(2016,1,13))
      beth.days.create(date: Date.new(2016,1,14))
    end

    it "marks a day as undoable" do
      day = subject.days.first
      subject.undoable(day)
      expect(subject.undoable_days.where(date: day.date).count).to eq(1)
    end

    it "shuffles the hero's day with another hero's day" do
      day = subject.days.first
      swapped_date = beth.days.first
      subject.undoable(day)
      expect(subject.days.first).to eq(swapped_date)
    end
  end
end
