defmodule Game.Renderer do
  @moduledoc """
  Renders the world as ASCII
  """
  alias Configs.Static

  def render(world) do
    renderables = world.players ++ world.npcs

    for y <- 0..(Static.height() - 1) do
      for x <- 0..(Static.width() - 1) do
        if npc_at?(renderables, x, y) do
          get_symbol(renderables, x, y)
        else
          " "
        end
      end
      |> Enum.join(".")
    end
    |> Enum.join("\r\n")
  end

  defp npc_at?(npcs, x, y) do
    Enum.any?(npcs, fn c -> c.x == x && c.y == y end)
  end

  defp get_symbol(npcs, x, y) do
    case Enum.find(npcs, fn c -> c.x == x && c.y == y end) do
      nil ->
        "?"

      character ->
        if character.symbol == nil do
          "?"
        else
          character.symbol
        end
    end
  end
end
