defmodule CivExplore do
  def run_server do
    game = GameServer.start()
    Server.Listener.start(4000, game)
    Process.sleep(:infinity)
  end

  def run_client do
    {:ok, socket} = :gen_tcp.connect(~c"localhost", 4000, [:binary, packet: 4])
    Client.Network.start(socket)
    Client.Input.start(socket)
    Process.sleep(:infinity)
  end
end
