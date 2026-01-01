defmodule CivExplore do
  alias Game.World
  alias Game.Renderer

  def run do
    # Put standard_io into raw binary mode (instant keys!)
    :ok = :io.setopts(:standard_io, binary: true, encoding: :unicode)

    pid = spawn(fn -> loop(World.new()) end)
    spawn(fn -> input_loop(pid) end)

    Process.sleep(:infinity)
  end

  defp loop(world) do
    world =
      receive do
        {:move, direction} ->
          World.move_player(world, 1, direction)

        {:exit} ->
          System.stop(0)
      after
        0 -> world
      end

    IO.write("\e[2J\e[H")
    IO.puts(Renderer.render(world))

    Process.sleep(500)
    loop(World.tick(world))
  end

  defp input_loop(game_pid) do
    case IO.getn(:stdio, "", 1) do
      "w" -> send(game_pid, {:move, :up})
      "a" -> send(game_pid, {:move, :left})
      "s" -> send(game_pid, {:move, :down})
      "d" -> send(game_pid, {:move, :right})
      "q" -> send(game_pid, {:exit})
      # For arrow keys
      "\e" -> read_escape_sequence(game_pid)
      _ -> :ok
    end

    Process.sleep(50)
    input_loop(game_pid)
  end

  defp read_escape_sequence(game_pid) do
    case IO.getn(:stdio, "", 3) do
      "[A" -> send(game_pid, {:move, :up})
      "[B" -> send(game_pid, {:move, :down})
      "[C" -> send(game_pid, {:move, :right})
      "[D" -> send(game_pid, {:move, :left})
      _ -> :ok
    end
  end
end

