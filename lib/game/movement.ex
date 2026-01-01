defmodule Game.Movement do
  def move(character, :up), do: %{character | y: character.y - 1}
  def move(character, :down), do: %{character | y: character.y + 1}
  def move(character, :left), do: %{character | x: character.x - 1}
  def move(character, :right), do: %{character | x: character.x + 1}
end
