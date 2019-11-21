class Game < ApplicationRecord
  validates :name, presence: true
  has_many :pieces

end
