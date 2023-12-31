# frozen_string_literal: true

# Vector class represents a 2D vector with x and y coordinates.
class Vector
  attr_reader :x, :y

  def initialize(pos_x, pos_y)
    @x = pos_x
    @y = pos_y
    @vec = Vector2.new
    @vec.x = @x
    @vec.y = @y
  end

  def to_raylib
    @vec
  end

  def x=(value)
    @x = value
    @vec.x = @x
  end

  def y=(value)
    @y = value
    @vec.y = @y
  end
end

# The Texture class loads and stores texture assets used for rendering sprites and images.
# It handles loading the image data and creating the OpenGL texture.
class Texture
  @@textures = {}

  def initialize(path, rotation = 0, scale = 1, color = WHITE)
    @@textures[path] = LoadTexture(path) if @@textures[path].nil?
    @texture = @@textures[path]
    @rotation = rotation
    @scale = scale
    @color = color
  end

  def draw(vector)
    DrawTextureEx(@texture, vector.to_raylib, @rotation, @scale, @color)
  end

  def height
    @texture.height
  end

  def width
    @texture.width
  end

  def self.unload
    @@textures.each_value { |texture| UnloadTexture(texture) }
  end
end

class Parallax
  def initialize(texture, speed, limit, vector_position)
    @texture = texture
    @speed = speed
    @limit = limit
    @vector_position = vector_position
  end

  def draw
    @vector_position.x = (@vector_position.x + @speed * GetFrameTime()) % @limit
    draw_position = Vector.new(-@vector_position.x, @vector_position.y)
    @texture.draw(draw_position)
  end

  def unload
    @texture.unload
  end

  def height
    @texture.height
  end
end
