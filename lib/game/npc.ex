defmodule Game.NPC do
  @moduledoc """
    A simple NPC that can move randomly to the grid
  """
  defstruct [:x, :y, :race]

  @directions [:up, :down, :left, :right]

  def random_move(npc) do
    direction = Enum.random(@directions)
    move(npc, direction)
  end

  defp move(npc, :up), do: %{npc | y: npc.y - 1}
  defp move(npc, :down), do: %{npc | y: npc.y + 1}
  defp move(npc, :left), do: %{npc | x: npc.x - 1}
  defp move(npc, :right), do: %{npc | x: npc.x + 1}
end
