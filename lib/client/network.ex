defmodule Client.Network do
  def start(socket) do
    spawn_link(fn -> loop(socket) end)
  end

  defp loop(socket) do
    receive do
      {:tcp, ^socket, data} ->
        world = :erlang.binary_to_term(data)
        Client.Renderer.render(world)
        loop(socket)

      {:tcp_closed, ^socket} ->
        IO.puts("Server closed connection")
        System.stop(0)

      {:tcp_error, ^socket, reason} ->
        IO.puts("TCP error: #{inspect(reason)}")
        System.stop(0)
    end
  end
end

