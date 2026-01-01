defmodule Game.NPC do
  @moduledoc """
    A simple NPC that can move randomly to the grid
  """
  defstruct [:x, :y, :race, :symbol]

  @directions [:up, :down, :left, :right]

  def random_move(npc) do
    direction = Enum.random(@directions)
    Game.Movement.move(npc, direction)
  end
end
