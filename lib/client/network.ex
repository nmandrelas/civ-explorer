defmodule Client.Network do
  def start(socket) do
    spawn_link(fn -> loop(socket) end)
  end

  defp loop(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        world = :erlang.binary_to_term(data)
        Client.Renderer.render(world)
        # <- MUST recurse
        loop(socket)

      {:error, :closed} ->
        IO.puts("Server closed connection")

      {:error, reason} ->
        IO.puts("TCP error: #{inspect(reason)}")
    end
  end
end

