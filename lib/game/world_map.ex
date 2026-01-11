defmodule Game.WorldMap do
  alias Configs.Static

  defstruct cells: %{}

  def new do
    cells =
      for x <- 0..(Static.world_map_width() - 1),
          y <- 0..(Static.world_map_height() - 1),
          into: %{} do
        {{x, y}, {Game.Tile.new()}}
      end

    %Game.WorldMap{cells: cells}
  end
end
