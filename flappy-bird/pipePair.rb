GAP = 50

class PipePair
  attr_reader :pipes

  def initialize(pos_y)
    @x = SCREEN_WIDTH
    @pipe = Pipe.new(:upper, 0)
    lower_y = rand((SCREEN_HEIGHT - @pipe.texture.height)..(SCREEN_HEIGHT - pos_y - @pipe.texture.height * 0.2))
    @pipes = [Pipe.new(:upper, lower_y - GAP - @pipe.texture.height), Pipe.new(:bottom, lower_y)]
    @remove = false
  end

  def update
    if @x > -@pipes[0].width
      dt = GetFrameTime()
      @pipes[0].update(dt)
      @pipes[1].update(dt)
    else
      @remove = true
    end
  end

  def draw
    @pipes[0].draw
    @pipes[1].draw
  end
end
