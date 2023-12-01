require 'raylib'
shared_lib_path = Gem::Specification.find_by_name('raylib-bindings').full_gem_path + '/lib/'

case RUBY_PLATFORM
when /mswin|msys|mingw|cygwin/
  Raylib.load_lib(shared_lib_path + 'libraylib.dll', raygui_libpath: shared_lib_path + 'raygui.dll', physac_libpath: shared_lib_path + 'physac.dll') when /darwin/
  Raylib.load_lib(shared_lib_path + 'libraylib.dylib', raygui_libpath: shared_lib_path + 'raygui.dylib', physac_libpath: shared_lib_path + 'physac.dylib')
when /linux/
  arch = RUBY_PLATFORM.split('-')[0]
  Raylib.load_lib(shared_lib_path + "libraylib.#{arch}.so", raygui_libpath: shared_lib_path + "raygui.#{arch}.so", physac_libpath: shared_lib_path + "physac.#{arch}.so")
else
  raise RuntimeError, "Unknown OS: #{RUBY_PLATFORM}"
end

include Raylib

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

BACKGROUND = Color.new
BACKGROUND.r = 40
BACKGROUND.g = 45
BACKGROUND.b = 52
BACKGROUND.a = 255

PADDLE_SPEED = 200

# Represents a paddle in the pong game
#
# Responsibilities:
# - Store position, dimensions and direction
# - Update position based on direction and time
class Paddle
  attr_writer :dy
  attr_reader :pos_x, :pos_y, :score

  def initialize(pos_x, pos_y, width, height)
    @pos_x = pos_x
    @pos_y = pos_y
    @width = width
    @height = height
    @dy = 0
    @score = 0
  end

  def update
    @pos_y =
      if @dy.negative?
        [@pos_y + @dy * GetFrameTime(), 0].max
      else
        [@pos_y + @dy * GetFrameTime(), SCREEN_HEIGHT - 100].min
      end
  end

  def draw
    DrawRectangle(@pos_x, @pos_y, @width, @height, RAYWHITE)
  end

  def rectangle
    rect = Rectangle.new
    rect.x = @pos_x
    rect.y = @pos_y
    rect.width = @width
    rect.height = @height
    rect
  end

  def increment_score
    @score += 1
  end
end

# Represents a ball in the pong game
#
# Responsibilities:
# - Store position, velocity
# - Update position based on velocity
# - Handle collisions and bounces
class Ball
  attr_accessor :pos_x, :pos_y, :dx, :dy
  attr_reader :radius

  def initialize(pos_x, pos_y, radius)
    @pos_x = pos_x
    @pos_y = pos_y
    @radius = radius
  end

  def reset(dx)
    @pos_x = SCREEN_WIDTH / 2 - 5
    @pos_y = SCREEN_HEIGHT / 2 - 5
    @dx = dx
    @dy = rand < 0.5 ? -100 : 100
  end

  def update
    @pos_x += @dx * GetFrameTime()
    @pos_y += @dy * GetFrameTime()
  end

  def draw
    DrawRectangle(@pos_x, @pos_y, @radius, @radius, RAYWHITE)
  end

  def collide?(paddle)
    CheckCollisionRecs(paddle.rectangle, rectangle)
  end

  def rectangle
    rect = Rectangle.new
    rect.x = @pos_x
    rect.y = @pos_y
    rect.width = @radius
    rect.height = @radius
    rect
  end
end

def draw_text(text, pos_x, pos_y)
  DrawText(text, pos_x, pos_y, 20, RAYWHITE)
end

paddle1 = Paddle.new(10, 30, 5, 100)
paddle2 = Paddle.new(SCREEN_WIDTH - 15, SCREEN_HEIGHT - 130, 5, 100)
ball = Ball.new(SCREEN_WIDTH / 2 - 5, SCREEN_HEIGHT / 2 - 5, 10)
game_state = 'start'
winner_player = nil

if rand < 0.5
  serving_player = 1
  ball.reset rand(200..400)
else
  serving_player = 2
  ball.reset rand(-400..-200)
end

InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, 'Pong')
SetTargetFPS(60)

InitAudioDevice()
sounds = {
  paddle_hit: LoadSound('sounds/paddle_hit.wav'),
  score: LoadSound('sounds/score.wav'),
  wall_hit: LoadSound('sounds/wall_hit.wav')
}

until WindowShouldClose()
  BeginDrawing()
  ClearBackground(BACKGROUND)

  paddle1.dy =
    if IsKeyDown(KEY_W)
      -PADDLE_SPEED
    elsif IsKeyDown(KEY_S)
      +PADDLE_SPEED
    else
      0
    end
  paddle2.dy =
    if IsKeyDown(KEY_UP)
      -PADDLE_SPEED
    elsif IsKeyDown(KEY_DOWN)
      +PADDLE_SPEED
    else
      0
    end

  if IsKeyPressed(KEY_SPACE)
    case game_state
    when 'start'
      game_state = 'serve'
    when 'serve'
      game_state = 'play'
    when 'done'
      paddle1 = Paddle.new(10, 30, 5, 100)
      paddle2 = Paddle.new(SCREEN_WIDTH - 15, SCREEN_HEIGHT - 130, 5, 100)
      ball = Ball.new(SCREEN_WIDTH / 2 - 5, SCREEN_HEIGHT / 2 - 5, 10)
      ball.reset serving_player == 1 ? rand(200..400) : rand(-400..-200)
      game_state = 'start'
    end
  end

  paddle1.update
  paddle2.update

  if ball.collide?(paddle1)
    PlaySound(sounds[:paddle_hit])
    ball.dx = -ball.dx * 1.1
    ball.pos_x = paddle1.pos_x + 5
    ball.dy =
      if ball.dy.negative?
        -rand(10..150)
      else
        rand(10..150)
      end
  end

  if ball.collide?(paddle2)
    PlaySound(sounds[:paddle_hit])
    ball.dx = -ball.dx * 1.1
    ball.pos_x = paddle2.pos_x - ball.radius
    ball.dy =
      if ball.dy.negative?
        -rand(10..150)
      else
        rand(10..150)
      end
  end

  if ball.pos_y <= 0
    PlaySound(sounds[:wall_hit])
    ball.pos_y = 0
    ball.dy = -ball.dy
  end

  if ball.pos_y >= SCREEN_HEIGHT - 4
    PlaySound(sounds[:wall_hit])
    ball.pos_y = SCREEN_HEIGHT - 4
    ball.dy = -ball.dy
  end

  if ball.pos_x <= 0
    PlaySound(sounds[:score])
    paddle2.increment_score
    ball.reset rand(-200..-100)
    if paddle2.score == 10
      game_state = 'done'
      winner_player = 2
      serving_player = 1
    else
      game_state = 'serve'
      serving_player = 2
    end
  end

  if ball.pos_x > SCREEN_WIDTH
    PlaySound(sounds[:score])
    paddle1.increment_score
    ball.reset rand(100..200)
    if paddle1.score == 10
      game_state = 'done'
      winner_player = 1
      serving_player = 2
    else
      game_state = 'serve'
      serving_player = 1
    end
  end

  game_state == 'play' && ball.update

  paddle1.draw
  paddle2.draw
  ball.draw
  draw_text(paddle1.score.to_s, SCREEN_WIDTH / 2 - 50, SCREEN_HEIGHT / 3)
  draw_text(paddle2.score.to_s, SCREEN_WIDTH / 2 + 30, SCREEN_HEIGHT / 3)

  case game_state
  when 'start'
    draw_text('Welcome to Pong!', (SCREEN_WIDTH - MeasureText('Welcome to Pong!', 20)) / 2, 10)
    draw_text('Press Enter to begin!', (SCREEN_WIDTH - MeasureText('Press Enter to begin!', 20)) / 2, 40)
  when 'serve'
    draw_text("Player #{serving_player}'s serve", (SCREEN_WIDTH - MeasureText("Player #{serving_player}'s serve", 20)) / 2, 10)
    draw_text('Press Enter to serve!', (SCREEN_WIDTH - MeasureText('Press Enter to serve!', 20)) / 2, 40)
  when 'done'
    draw_text("Player #{winner_player} wins", (SCREEN_WIDTH - MeasureText("Player #{winner_player} wins", 20)) / 2, 10)
    draw_text('Press Enter to restart!', (SCREEN_WIDTH - MeasureText('Press Enter to restart!', 20)) / 2, 40)
  end

  EndDrawing()
end

sounds.each_pair do |_, sound|
  UnloadSound(sound)
end
CloseAudioDevice()
CloseWindow()
