class PlayState < BaseState
  def initialize
    super
    @bird = Bird.new
    @pipes_pair = []
    @timer = 0
    @scrolling = true
  end

  def update
    $state_machine.change(:scoreScreenState) if !@scrolling

    @bird.update GetFrameTime()

    @timer += GetFrameTime()

    if @timer > 2
      @pipes_pair.append(PipePair.new($textures[:ground].height))
      @timer = 0
    end

    @pipes_pair.each do |pipe|
      pipe.update
      if @bird.collides?(pipe.pipes[0]) or @bird.collides?(pipe.pipes[1])
        @scrolling = false
      end
    end
  end

  def render
    @pipes_pair.each(&:draw)
    @bird.draw
  end
end
