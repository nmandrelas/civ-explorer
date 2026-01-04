defmodule CivExplore do
  alias Game.World
  alias Game.Renderer

  def run do
    :ok = :shell.start_interactive({:noshell, :raw})

    game_pid = spawn_link(fn -> loop(World.new()) end)
    spawn_link(fn -> input_loop(game_pid) end)

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
    case IO.getn("", 1) do
      "w" -> send(game_pid, {:move, :up})
      "a" -> send(game_pid, {:move, :left})
      "s" -> send(game_pid, {:move, :down})
      "d" -> send(game_pid, {:move, :right})
      "q" -> send(game_pid, {:exit})
      _ -> :ok
    end

    input_loop(game_pid)
  end
end

