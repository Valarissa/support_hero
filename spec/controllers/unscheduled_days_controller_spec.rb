require 'rails_helper'

RSpec.describe UnscheduledDaysController, type: :controller do

  render_views

  let!(:tom){ Hero.create(name: "Tom") }
  let!(:day){ Day.create(date: Date.new(2016,1,5)) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "collects all unassigned days" do
      get :index
      days = Day.unscoped.where(hero_id: nil)
      expect(assigns(:unassigned_days)).to eq(days)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, {id: day.id}
      expect(response).to have_http_status(:success)
    end

    it "allows you to choose all applicable heroes" do
      beth = Hero.create(name: "Beth")
      undoable_day = beth.undoable_days.create(day_id: day.id)
      get :edit, {id: day.id}
      expect(assigns(:heroes)).to eq([tom])
    end
  end

  describe "PUT #update" do
    it "redirects to the unscheduled days index" do
      put :update, {id: day.id, day: {hero_id: tom.id}}
      expect(response).to redirect_to(unscheduled_days_path)
    end

    it "adds the hero given to the unassigned day" do
      put :update, {id: day.id, day: {hero_id: tom.id}}
      expect(day.reload.hero).to eq(tom)
    end
  end

end
