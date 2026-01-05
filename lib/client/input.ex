defmodule Client.Input do
  def start(socket) do
    spawn_link(fn -> loop(socket) end)
  end

  defp loop(socket) do
    case IO.getn(:stdio, "", 1) do
      nil ->
        :ok

      key ->
        :gen_tcp.send(socket, key <> "\n")
        loop(socket)
    end
  end
end
