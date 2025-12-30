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
          get_symbol(world.npcs, x, y)
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

  defp get_symbol(npcs, x, y) do
    case Enum.find(npcs, fn %NPC{x: nx, y: ny} -> nx == x && ny == y end) do
      nil -> "."
      %NPC{race: race} -> symbol_for_race(race)
    end
  end

  defp symbol_for_race(race) do
    case race do
      "human" -> "H"
      "goblin" -> "g"
      "orc" -> "O"
      _ -> "?"
    end
  end
end
