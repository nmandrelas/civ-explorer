defmodule Game.World do
  @moduledoc """
  Holds the world state and enforces boundaries.
  """

  alias Game.NPC

  @width 16
  @height 16

  defstruct npcs: []

  def new do
    npcs = [
      %NPC{x: 8, y: 8, race: "human"},
      %NPC{x: 6, y: 6, race: "goblin"},
      %NPC{x: 8, y: 4, race: "orc"}
    ]

    %Game.World{npcs: npcs}
  end

  def tick(world) do
    moved_npcs =
      world.npcs
      |> Enum.map(fn npc ->
        npc |> NPC.random_move() |> clamp()
      end)

    %{world | npcs: moved_npcs}
  end

  defp clamp(%NPC{x: x, y: y} = npc) do
    %NPC{
      npc
      | x: clamp_value(x, 0, @width - 1),
        y: clamp_value(y, 0, @height - 1)
    }
  end

  defp clamp_value(value, min, max) do
    value
    |> max(min)
    |> min(max)
  end
end
