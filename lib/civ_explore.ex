defmodule CivExplore do
  alias Game.World

  def run do
    :ok = :shell.start_interactive({:noshell, :raw})

    renderer = Engine.RenderLoop.start()
    game = Engine.Game.start(World.new(), renderer)
    Engine.Ticker.start(game)
    Engine.Input.start(game)

    Process.sleep(:infinity)
  end
end
