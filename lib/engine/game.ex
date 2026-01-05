defmodule Engine.Game do
  alias Game.World

  def start(world, renderer_pid) do
    spawn_link(fn -> loop(world, renderer_pid) end)
  end

  defp loop(world, renderer_pid) do
    receive do
      {:move, dir} ->
        new_world = World.move_player(world, 1, dir)
        notify(renderer_pid, new_world)
        loop(new_world, renderer_pid)

      :tick ->
        new_world = World.tick(world)
        notify(renderer_pid, new_world)
        loop(new_world, renderer_pid)

      {:exit} ->
        exit(:normal)
    end
  end

  defp notify(renderer_pid, world) do
    send(renderer_pid, {:world, world})
  end
end
