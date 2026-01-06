defmodule Server.Listener do
  def start(port, game_pid) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: 4, active: false, reuseaddr: true])

    spawn_link(fn -> accept_loop(socket, game_pid) end)
  end

  defp accept_loop(socket, game) do
    {:ok, client} = :gen_tcp.accept(socket)
    pid = Server.ClientSession.start(client, game)
    :gen_tcp.controlling_process(client, pid)
    :inet.setopts(client, active: true)
    accept_loop(socket, game)
  end
end
