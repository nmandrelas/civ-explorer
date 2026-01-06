defmodule Client.Input do
  def start(socket) do
    spawn_link(fn -> loop(socket) end)
  end

  defp loop(socket) do
    case IO.gets("") do
      {:error, _} ->
        :ok

      line ->
        trimmed = String.trim(line)

        if trimmed in ~w(w a s d) do
          :gen_tcp.send(socket, trimmed)
        end

        loop(socket)
    end
  end
end

