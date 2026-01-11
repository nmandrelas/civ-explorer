defmodule Game.Tile do
  alias Game.NPC
  alias Configs.Static

  defstruct npcs: [], players: %{}

  def new do
    npcs = [
      %NPC{x: 8, y: 8, race: "human", symbol: "H"},
      %NPC{x: 6, y: 6, race: "goblin", symbol: "g"},
      %NPC{x: 8, y: 4, race: "orc"}
    ]

    %Game.Tile{npcs: npcs, players: %{}}
  end

  def add_player(tile, id) do
    put_in(tile.players[id], %{x: 0, y: 0, symbol: "P", id: id})
  end

  def remove_player(tile, id) do
    %{tile | players: Map.delete(tile.players, id)}
  end

  def tick(tile) do
    moved_npcs =
      tile.npcs
      |> Enum.map(fn npc ->
        npc |> NPC.random_move() |> clamp()
      end)

    %{tile | npcs: moved_npcs}
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

  def move_player(tile, id, dir) do
    update_in(tile.players[id], fn p ->
      Game.Movement.move(p, dir)
    end)
  end
end
