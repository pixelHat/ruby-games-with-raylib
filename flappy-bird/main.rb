# frozen_string_literal: true

require_relative 'setup'
require_relative 'wrappers'
require_relative 'bird'
require_relative 'pipe'

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, 'Bird')
SetTargetFPS(60)
InitAudioDevice()

sounds = {
  paddle_hit: LoadSound('sounds/paddle_hit.wav'),
  score: LoadSound('sounds/score.wav'),
  wall_hit: LoadSound('sounds/wall_hit.wav')
}

textures = {
  background: Parallax.new(Texture.new('assets/background.png', 0, 2.5, WHITE), 60, 413 * 2.5, Vector.new(0, 0)),
  ground: Parallax.new(Texture.new('assets/ground.png', 0, 2, WHITE), 120, 800, Vector.new(0, SCREEN_HEIGHT - 32))
}

bird = Bird.new
pipes = []
timer = 0

until WindowShouldClose()
  bird.update GetFrameTime()

  timer += GetFrameTime()

  if timer > 1
    pipes.append(Pipe.new(textures[:ground].height))
    timer = 0
  end

  pipes.each do |pipe|
    pipe.update
    pipes.delete(pipe) if pipe.pos.x < -pipe.texture.width
  end

  BeginDrawing()
  textures[:background].draw
  pipes.each(&:draw)
  textures[:ground].draw
  bird.draw
  EndDrawing()
end

sounds.each_pair do |_, texture|
  UnloadSound(texture)
end
Texture.unload

CloseAudioDevice()
CloseWindow()
