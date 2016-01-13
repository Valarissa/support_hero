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
end
