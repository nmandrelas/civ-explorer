defmodule Engine.Input do
  def start(game_pid) do
    spawn_link(fn -> loop(game_pid) end)
  end

  defp loop(game_pid) do
    case IO.getn("", 1) do
      "w" -> send(game_pid, {:move, :up})
      "a" -> send(game_pid, {:move, :left})
      "s" -> send(game_pid, {:move, :down})
      "d" -> send(game_pid, {:move, :right})
      "q" -> send(game_pid, {:exit})
      _ -> :ok
    end

    loop(game_pid)
  end
end
