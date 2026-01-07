defmodule Client.Network do
  def start(socket) do
    renderer_pid = Engine.RenderLoop.start()
    spawn_link(fn -> loop(socket, renderer_pid) end)
  end

  defp loop(socket, renderer_pid) do
    # IO.inspect("Waiting for tcp msg")

    receive do
      {:tcp, ^socket, data} ->
        world = :erlang.binary_to_term(data)
        send(renderer_pid, {:world, world})
        loop(socket, renderer_pid)

      {:tcp_closed, ^socket} ->
        IO.puts("Server closed connection")
        System.stop(0)

      {:tcp_error, ^socket, reason} ->
        IO.puts("TCP error: #{inspect(reason)}")
        System.stop(0)
    end
  end
end
