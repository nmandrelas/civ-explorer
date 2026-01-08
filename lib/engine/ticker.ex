defmodule Engine.Ticker do
  @tick_ms 1000

  def start(game_pid) do
    spawn_link(fn -> loop(game_pid) end)
  end

  defp loop(game_pid) do
    send(game_pid, :tick)
    Process.send_after(self(), :next, @tick_ms)

    receive do
      :next -> loop(game_pid)
    end
  end
end
