class Piece < ApplicationRecord
  belongs_to :game

  def move_to!(x, y)
    opposing_piece = game.pieces.find_by(x_position: x, y_position: y)
    
    if opposing_piece.present? && opposing_piece.color != color
      opposing_piece.update_attributes(x_position: nil, y_position: nil, captured: true)
    elsif opposing_piece.present?
      return 'invalid move'
    end
    update_attributes(x_position: x, y_position: y)
  end

  def is_obstructed?(new_x, new_y)
    direction = move_direction(new_x, new_y)
    if direction == 'horizontal'
      if new_x > x
        (x + 1).upto(new_x - 1) do |x_current|
          return true if occupied?(x_current, y)
        end
      else
        (x - 1).downto(new_x + 1) do |x_current|
          return true if occupied?(x_current, y)
        end
      end
    elsif direction == 'vertical'
      if new_y > y
        (y + 1).upto(new_y - 1) do |y_current|
          return true if occupied?(x, y_current)
        end
      else
        (y - 1).downto(new_y + 1) do |y_current|
          return true if occupied?(x, y_current)
        end
      end
    elsif direction == 'diagonal'
      if new_x > x && new_y > y
        (x + 1).upto(new_x - 1) do |x_current|
          y_current = y + (x_current - x)
          return true if occupied?(x_current, y_current)
        end
      elsif new_x < x && new_y > y
        (x - 1).downto(new_x + 1) do |x_current|
          y_current = y = (x_current - x).abs
          return true if occupied?(x_current, y_current)
        end
      elsif new_x > x && new_y < y
        (x + 1).upto(new_x - 1) do |x_current|
          y_current = y - (x_current - x)
          return true if occupied?(x_current, y_current)
        end
      else
        (x - 1).downto(x_target + 1) do |x_current|
          y_current = y - (x_current - x).abs
          return true if occupied?(x_current, y_current)
        end
      end
    end
    false
  end

  def move_direction(new_x, new_y)
    return 'horizontal' if x != new_x && y == new_y
    return 'vertical' if x == new_x && y != new_y
    return 'diagonal' if (new_x - x).abs == (new_y - y).abs
    false
  end

  def occupied?(x_current, y_current)
    game.Piece.where(x: x_current, y: y_current).present?
  end

end


