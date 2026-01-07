defmodule Game.World do
  alias Game.NPC
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

  def move_player(world, id, dir) do
    update_in(world.players[id], fn p ->
      case dir do
        :up -> %{p | y: p.y - 1}
        :down -> %{p | y: p.y + 1}
        :left -> %{p | x: p.x - 1}
        :right -> %{p | x: p.x + 1}
      end
    end)
  end
end
