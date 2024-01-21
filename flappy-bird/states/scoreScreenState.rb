class ScoreScreenState < BaseState
  def render
    DrawText('You Lost!', SCREEN_WIDTH / 2 - MeasureText('You Lost!', 40) / 2, 100, 40, RAYWHITE)
    DrawText("Score: #{$score}", SCREEN_WIDTH / 2 - MeasureText("Score: #{$score}", 25) / 2, 150, 25, RAYWHITE)
    DrawText('Press Enter to Play Again', SCREEN_WIDTH / 2 - MeasureText('Press Enter to Play Again', 25) / 2, 400, 25, RAYWHITE)
  end

  def update
    IsKeyPressed(KEY_ENTER) and $state_machine.change(:titleScreenState)
  end
end
