defmodule GameServer do
  alias Game.World

  def start do
    game_server_pid = spawn_link(fn -> loop(World.new(), %{}) end)
    Engine.Ticker.start(game_server_pid)
    game_server_pid
  end

  defp loop(world, clients) do
    receive do
      {:join, client_pid} ->
        id = make_ref()
        world = World.add_player(world, id)
        clients = Map.put(clients, id, client_pid)
        send(client_pid, {:welcome, id, world})
        broadcast(world, clients)
        loop(world, clients)

      {:input, id, {:move, dir}} ->
        world = World.move_player(world, id, dir)
        broadcast(world, clients)
        loop(world, clients)

      :tick ->
        world = World.tick(world)
        broadcast(world, clients)
        loop(world, clients)

      {:disconnect, id} ->
        clients = Map.delete(clients, id)
        world = World.remove_player(world, id)
        broadcast(world, clients)
        loop(world, clients)
    end
  end

  defp broadcast(world, clients) do
    Enum.each(clients, fn {_id, pid} ->
      send(pid, {:world, world})
    end)
  end
end
