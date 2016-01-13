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
end
