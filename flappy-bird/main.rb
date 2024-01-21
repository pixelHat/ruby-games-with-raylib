# frozen_string_literal: true

require_relative 'setup'
require_relative 'wrappers'
require_relative 'bird'
require_relative 'pipe'
require_relative 'pipePair'
require_relative 'stateMachine'
require_relative 'states/playState'
require_relative 'states/titleScreenState'
require_relative 'states/scoreScreenState'

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

$textures = {
  background: Parallax.new(Texture.new('assets/background.png', 0, 2.5, WHITE), 60, 413 * 2.5, Vector.new(0, 0)),
  ground: Parallax.new(Texture.new('assets/ground.png', 0, 2, WHITE), 120, 800, Vector.new(0, SCREEN_HEIGHT - 32))
}

$state_machine = StateMachine.new(
  {
    playState: PlayState,
    titleScreenState: TitleScreenState,
    scoreScreenState: ScoreScreenState
  }
)
$state_machine.change(:titleScreenState)
$score = 10

until WindowShouldClose()
  $state_machine.update
  BeginDrawing()
  $textures[:background].draw
  $state_machine.render
  $textures[:ground].draw
  EndDrawing()
end

sounds.each_pair do |_, texture|
  UnloadSound(texture)
end
Texture.unload

CloseAudioDevice()
CloseWindow()
