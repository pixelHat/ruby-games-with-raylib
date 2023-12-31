# frozen_string_literal: true

# Pipe class represents a pipe obstacle in the game
class Pipe
  attr_reader :pos, :texture

  def initialize(ground_y)
    @texture = Texture.new('assets/pipe.png')
    @pos = Vector.new(SCREEN_WIDTH, rand((SCREEN_HEIGHT - @texture.height)..(SCREEN_HEIGHT - ground_y)))
    @scroll = -60
  end

  def update
    @pos.x += @scroll * GetFrameTime()
  end

  def draw
    @texture.draw(@pos)
  end
end
