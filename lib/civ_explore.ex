defmodule CivExplore do
  @moduledoc """
  Documentation for `CivExplore`.
  """

  alias Game.World
  alias Game.Renderer

  def run do
    loop(World.new())
  end

  defp loop(world) do
    IO.write("\e[H\e[2J")
    IO.puts(Renderer.render(world))

    Process.sleep(500)

    world |> World.tick() |> loop()
  end
end
