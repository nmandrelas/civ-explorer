defmodule Engine.RenderLoop do
  alias Game.Renderer

  @fps 30
  @frame_ms div(1000, @fps)

  def start(game_pid) do
    spawn_link(fn -> loop(game_pid) end)
  end

  defp loop(game_pid) do
    send(game_pid, {:render, self()})

    receive do
      {:world, world} ->
        IO.write("\e[2J\e[1;1H")
        IO.write(Renderer.render(world))
    end

    Process.send_after(self(), :next, @frame_ms)

    receive do
      :next -> loop(game_pid)
    end
  end
end
