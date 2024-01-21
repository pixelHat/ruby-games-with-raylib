require_relative 'wrappers'

class Bird
  def initialize
    @texture = Texture.new('assets/bird.png', 0, 2, WHITE)
    @width = @texture.width
    @height = @texture.height
    @vec = Vector.new(SCREEN_WIDTH / 2 - (@width / 2), SCREEN_HEIGHT / 2 - (@height / 2))
    @dy = 0
    @gravity = 20
  end

  def draw
    @texture.draw(@vec)
  end

  def update(delta_time)
    IsKeyPressed(KEY_SPACE) and @dy = -5
    @dy += @gravity * delta_time
    @vec.y += @dy
  end

  def collides?(pipe)
    CheckCollisionRecs(pipe.rectangle, rectangle)
  end

  def rectangle
    rect = Rectangle.new
    rect.x = @vec.x
    rect.y = @vec.y
    rect.width = @texture.width
    rect.height = @texture.height
    rect
  end
end
