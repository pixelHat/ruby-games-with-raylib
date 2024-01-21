class BaseState
  def render; end
  def update; end
  def enter(params = nil); end
  def exit; end
end

class StateMachine
  def initialize(states = [])
    @states = states
    @current = BaseState.new
  end

  def render
    @current.render
  end

  def update
    @current.update
  end

  def change(state_name, params = nil)
    @current.exit
    @current = @states[state_name].new
    @current.enter(params)
  end
end
