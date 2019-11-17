require 'rails_helper'

RSpec.describe Piece, type: :model do
  it "is valid with valid atributes" do
    expect(Piece.new).to be_valid
  end
end
