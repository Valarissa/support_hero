require 'rails_helper'

RSpec.describe UndoablesController, type: :controller do

  render_views

  before do
    Date.stub(today: Date.new(2016, 1, 10)) # Freeze tests in time
  end

  let!(:tom){ Hero.create(name: "Tom") }
  let!(:day){ tom.days.create(date: Date.new(2016, 1, 11)) }
  let!(:beth){ Hero.create(name: "Beth") }
  let!(:swap_day){ beth.days.create(date: Date.new(2016, 1, 12)) }


  describe "GET #index" do
    it "returns http success" do
      get :index, hero_id: tom.id
      expect(response).to have_http_status(:success)
    end

    it "gathers all the hero's days" do
      undoable = tom.undoable_days.create(day: day)
      get :index, hero_id: tom.id
      expect(assigns(:undoable_days)).to eq([undoable.day])
    end
  end

  describe "POST #create" do
    it "redirects to the hero's show page" do
      post :create, hero_id: tom.id, day_id: day.id
      expect(response).to redirect_to(hero_path(tom))
    end

    it "creates a new UndoableDay for the hero" do
      expect{post :create, hero_id: tom.id, day_id: day.id}.to change{tom.undoable_days.count}.from(0).to(1)
    end

    it "assigns the newly orphaned day to another person" do
      expect{post :create, hero_id: tom.id, day_id: day.id}.to change{day.reload.hero}.from(tom).to(beth)
    end

    it "assigns the hero a day from the hero taking over" do
      expect{post :create, hero_id: tom.id, day_id: day.id}.to change{swap_day.reload.hero}.from(beth).to(tom)
    end
  end

  describe "DELETE #destroy" do
    let!(:undoable){ tom.undoable(day) }

    it "redirects to the hero's show page" do
      delete :destroy, hero_id: tom.id, id: undoable.id
      expect(response).to redirect_to(hero_path(tom))
    end

    it "creates a new UndoableDay for the hero" do
      expect{delete :destroy, hero_id: tom.id, id: undoable.id}.to change{tom.undoable_days.count}.from(1).to(0)
    end

    it "assigns the hero with the day they spurned as atonement" do
      expect{delete :destroy, hero_id: tom.id, id: undoable.id}.to change{day.reload.hero}.from(beth).to(tom)
    end
  end

end
