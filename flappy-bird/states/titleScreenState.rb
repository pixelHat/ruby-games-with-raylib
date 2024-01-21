class TitleScreenState < BaseState
  def render
    DrawText('Bird Game', SCREEN_WIDTH / 2 - MeasureText('Bird Game', 40) / 2, 100, 40, RAYWHITE)
    DrawText('Press Enter', SCREEN_WIDTH / 2 - MeasureText('Press Enter', 25) / 2, 150, 25, RAYWHITE)
  end

  def update
    IsKeyPressed(KEY_ENTER) and $state_machine.change(:playState)
  end
end
