defmodule CivExplore do
  @moduledoc """
  Documentation for `CivExplore`.
  """

  alias Game.World
  alias Game.Renderer

  def run do
    spawn(fn -> input_loop(self()) end)
    loop(World.new())
  end

  defp loop(world) do
    world =
      receive do
        {:move, direction} ->
          IO.puts(direction)
          World.move_player(world, 1, direction)
      after
        0 -> world
      end

    IO.puts(Enum.at(world.players, 0).x)
    # IO.write("\e[H\e[2J")
    IO.puts(Renderer.render(world))

    Process.sleep(500)

    world |> World.tick() |> loop()
  end

  # Separate process to read input without blocking
  defp input_loop(game_pid) do
    case IO.getn(:stdio, "", 1) do
      "w" -> send(game_pid, {:move, :up})
      "a" -> send(game_pid, {:move, :left})
      "s" -> send(game_pid, {:move, :down})
      "d" -> send(game_pid, {:move, :right})
      # Quit
      "q" -> System.stop(0)
      _ -> :ok
    end

    # Don't hog CPU
    Process.sleep(50)
    input_loop(game_pid)
  end
end
