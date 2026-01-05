defmodule Server.ClientSession do
  def start(socket, game_pid) do
    spawn_link(fn -> init(socket, game_pid) end)
  end

  defp init(socket, game) do
    send(game, {:join, self()})
    IO.puts("Init success")
    await_welcome(socket, game)
  end

  # ---- PHASE 1: wait for ID ----
  defp await_welcome(socket, game) do
    receive do
      {:welcome, id, world} ->
        IO.puts("welcome received")
        active(socket, game, id)
        send_world(socket, world)
    end
  end

  # ---- PHASE 2: normal operation ----
  defp active(socket, game, id) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        IO.inspect(data)

        case String.trim(data) do
          "w" -> send(game, {:input, id, {:move, :up}})
          "a" -> send(game, {:input, id, {:move, :left}})
          "s" -> send(game, {:input, id, {:move, :down}})
          "d" -> send(game, {:input, id, {:move, :right}})
          _ -> :ok
        end

        active(socket, game, id)

      {:error, _} ->
        send(game, {:disconnect, id})
        :gen_tcp.close(socket)
    end
  end

  defp send_world(socket, world) do
    binary = :erlang.term_to_binary(world)
    :gen_tcp.send(socket, binary)
  end
end

