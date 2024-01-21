# frozen_string_literal: true

# Pipe class represents a pipe obstacle in the game
class Pipe
  attr_reader :pos, :texture

  def initialize(orientation, ground_y)
    @y = ground_y
    @orientation = orientation
    @texture = Texture.new('assets/pipe.png', 0, orientation == :upper ? -1 : 1)
    @pos = Vector.new(orientation == :upper ? SCREEN_WIDTH + @texture.width : SCREEN_WIDTH, ground_y)
    @scroll = -120
  end

  def update(dt)
    @pos.x += @scroll * dt
  end

  def draw
    @texture.draw(@pos)
  end

  def width
    @texture.width
  end

  def rectangle
    rect = Rectangle.new
    rect.x = @pos.x - ((@texture.width if @orientation == :upper) or 0)
    rect.y = @pos.y - ((@texture.height if @orientation == :upper) or 0)
    rect.width = @texture.width
    rect.height = @texture.height
    rect
  end
end
