class Game < ApplicationRecord
  belongs_to :user
  has_many :pieces


  scope :available, -> {joins(:users).where('users.count < 2')}
end

