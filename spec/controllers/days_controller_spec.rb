require 'rails_helper'

RSpec.describe DaysController, type: :controller do

  render_views

  let(:tom){ Hero.create(name: "Tom") }
  let(:beth){ Hero.create(name: "Beth") }

  describe "GET #edit" do
    it "returns http success" do
      day = tom.days.create(date: Date.new(2016,1,11))
      swap_day = beth.days.create(date: Date.new(2016,1,12))
      get :edit, {id: day.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    let(:day){ tom.days.create(date: Date.new(2016,1,11)) }
    let(:swap_day){ beth.days.create(date: Date.new(2016,1,12)) }

    it "redirects to the hero who originally owned the day" do
      put :update, {id: day.id, swap_id: swap_day.id}
      expect(response).to redirect_to(hero_path(tom))
    end

    it "exchanges the owner of the days given" do
      put :update, {id: day.id, swap_id: swap_day.id}
      expect(day.reload.hero).to eq(beth)
      expect(swap_day.reload.hero).to eq(tom)
    end
  end

end
