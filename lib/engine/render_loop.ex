defmodule Engine.RenderLoop do
  alias Game.Renderer

  def start do
    spawn_link(fn ->
      loop()
    end)
  end

  defp loop do
    receive do
      {:world, world} ->
        IO.write("\e[2J\e[1;1H")
        IO.write(Renderer.render(world))
    end

    loop()
  end
end
