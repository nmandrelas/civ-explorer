defmodule Game.World do
  alias Game.NPC
  alias Configs.Static

  defstruct npcs: [], players: %{}

  def new do
    npcs = [
      %NPC{x: 8, y: 8, race: "human", symbol: "H"},
      %NPC{x: 6, y: 6, race: "goblin", symbol: "g"},
      %NPC{x: 8, y: 4, race: "orc"}
    ]

    %Game.World{npcs: npcs, players: %{}}
  end

  def add_player(world, id) do
    put_in(world.players[id], %{x: 0, y: 0, symbol: "P", id: id})
  end

  def remove_player(world, id) do
    %{world | players: Map.delete(world.players, id)}
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
      | x: clamp_value(x, 0, Static.width() - 1),
        y: clamp_value(y, 0, Static.height() - 1)
    }
  end

  defp clamp_value(value, min, max) do
    value
    |> max(min)
    |> min(max)
  end

  def move_player(world, id, dir) do
    update_in(world.players[id], fn p ->
      Game.Movement.move(p, dir)
    end)
  end
end
