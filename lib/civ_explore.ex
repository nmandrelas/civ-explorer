defmodule CivExplore do
  alias Game.World

  def run do
    :ok = :shell.start_interactive({:noshell, :raw})

    game = Engine.Game.start(World.new())
    Engine.Ticker.start(game)
    Engine.RenderLoop.start(game)
    Engine.Input.start(game)

    Process.sleep(:infinity)
  end
end

