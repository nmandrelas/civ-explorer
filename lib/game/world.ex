defmodule Game.World do
  defstruct players: %{}

  def new do
    %__MODULE__{}
  end

  def add_player(world, id) do
    put_in(world.players[id], %{x: 0, y: 0})
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
