class Game < ApplicationRecord
  has_many :pieces, dependent: false
end
