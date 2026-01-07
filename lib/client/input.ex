defmodule Client.Input do
  def start(socket) do
    spawn_link(fn ->
      :ok = :shell.start_interactive({:noshell, :raw})
      loop(socket)
    end)
  end

  defp loop(socket) do
    case IO.read(:stdio, 1) do
      :eof ->
        :ok

      char ->
        if char in ~w(w a s d) do
          :gen_tcp.send(socket, char)
        end

        loop(socket)
    end
  end
end
