require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe "games#new action" do
    it "should successfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "games#create action" do
    it "should successfully create a new game in our database" do
      post :create, params: { game: { name: 'Test Game' } }
      expect(response).to redirect_to root_path
      game = Game.last
      expect(game.name).to eq("Test Game")
    end

    it "should properly deal with validation errors" do
      post :create, params: { game: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Game.count).to eq Game.count
    end
  end
end