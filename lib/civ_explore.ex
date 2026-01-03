defmodule CivExplore do
  alias Game.World
  alias Game.Renderer

  def run do
    # Only try to switch to raw mode if we have a real TTY
    raw_mode_enabled = enable_raw_mode()

    pid = spawn(fn -> loop(World.new()) end)
    spawn(fn -> input_loop(pid, raw_mode_enabled) end)

    Process.sleep(:infinity)
  end

  # Try to enable raw mode, return true/false
  defp enable_raw_mode do
    # Simple TTY check
    if IO.gets(:stdio, "") != :eof do
      case System.cmd("stty", ["-g"]) do
        {saved, 0} ->
          saved = String.trim(saved)
          System.cmd("stty", ["raw", "-echo"])
          # Store saved mode in process dictionary for restore
          Process.put(:saved_stty, saved)
          true

        _ ->
          false
      end
    else
      false
    end
  end

  # Restore terminal on normal exit or crash
  def terminate(_reason, _state) do
    if saved = Process.get(:saved_stty) do
      System.cmd("stty", String.split(saved))
      IO.puts("\nTerminal restored.")
    end
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

  defp input_loop(game_pid, raw_mode_enabled) do
    input =
      if raw_mode_enabled do
        IO.getn(:stdio, "", 1)
      else
        # Fallback: read full line (requires Enter)
        case IO.gets(:stdio, "") do
          :eof -> ""
          line -> String.trim_trailing(line, "\n")
        end
      end

    case input do
      "w" -> send(game_pid, {:move, :up})
      "a" -> send(game_pid, {:move, :left})
      "s" -> send(game_pid, {:move, :down})
      "d" -> send(game_pid, {:move, :right})
      "q" -> send(game_pid, {:exit})
      _ -> :ok
    end

    Process.sleep(50)
    input_loop(game_pid, raw_mode_enabled)
  end
end
