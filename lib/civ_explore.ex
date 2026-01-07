defmodule CivExplore do
  def run_server do
    game = GameServer.start()
    Server.Listener.start(4010, game)
    Process.sleep(:infinity)
  end

  def run_client do
    {:ok, socket} = :gen_tcp.connect(~c"localhost", 4010, [:binary, packet: 4, active: false])
    :ok = :shell.start_interactive({:noshell, :raw})

    net_pid = Client.Network.start(socket)
    :gen_tcp.controlling_process(socket, net_pid)
    :inet.setopts(socket, active: true)

    Client.Input.start(socket)
    Process.sleep(:infinity)
  end
end
