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
      User.create(
        email: "dummyEmail1@gmail.com",
        password: "secretPassword",
        password_confirmation: "secretPassword"
      )
      
      post :create, params: { game: { name: 'Test Game' } }
      expect(response).to redirect_to game_path(Game.last.id)
      game = Game.last
      expect(game.name).to eq("Test Game")
    end
    it "should properly deal with validation errors" do

    end
  end
end
