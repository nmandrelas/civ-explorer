defmodule Client.Renderer do
  def render(world) do
    IO.write("\e[2J\e[1;1H")

    Enum.each(world.players, fn {id, p} ->
      IO.puts("#{inspect(id)} @ #{p.x},#{p.y}")
    end)
  end
end
