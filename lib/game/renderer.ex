defmodule Game.Renderer do
  @moduledoc """
  Renders the world as ASCII
  """
  alias Game.NPC

  @width 16
  @height 16

  def render(world) do
    for y <- 0..(@height - 1) do
      for x <- 0..(@width - 1) do
        if npc_at?(world.npcs, x, y) do
          "@"
        else
          " "
        end
      end
      |> Enum.join(".")
    end
    |> Enum.join("\n")
  end

  defp npc_at?(npcs, x, y) do
    Enum.any?(npcs, fn %NPC{x: nx, y: ny} -> nx == x && ny == y end)
  end
end
