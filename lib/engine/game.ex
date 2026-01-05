defmodule Engine.Game do
  alias Game.World

  def start(initial_world) do
    spawn_link(fn -> loop(initial_world) end)
  end

  defp loop(world) do
    receive do
      {:move, dir} ->
        loop(World.move_player(world, 1, dir))

      :tick ->
        loop(World.tick(world))

      {:render, from} ->
        send(from, {:world, world})
        loop(world)

      {:exit} ->
        exit(:normal)
    end
  end
end
