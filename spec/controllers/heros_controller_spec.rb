require 'rails_helper'

RSpec.describe HerosController, type: :controller do

  render_views

  let(:tom){ Hero.create(name: "Tom") }
  let(:beth){ Hero.create(name: "Beth") }

  describe "GET #index" do
    it "returns http success" do
      [tom, beth] # silly way to just use the existing lets
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, id: tom.id
      expect(response).to have_http_status(:success)
    end

    it "gathers all the hero's days" do
      day = tom.days.create(date: Date.new(2016,1,11))
      get :show, id: tom.id
      expect(assigns(:days)).to eq([day])
    end
  end

end
