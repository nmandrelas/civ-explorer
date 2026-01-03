defmodule Game.Counter do
  use TermUI.Elm

  alias TermUI.Event
  alias TermUI.Layout.Constraint

  def init(_opts) do
    %{count: 0}
  end

  def event_to_msg(%Event.Key{key: "q"}, _state), do: {:msg, :quit}
  def event_to_msg(_, _), do: :ignore

  def update(:quit, state), do: {state, [:quit]}

  def view(state) do
    stack(:vertical, [
      stack(:horizontal, [
        text("Visible 1"),
        text("Visible 2")
      ]),
      stack(:horizontal, []),
      text("Also visible"),
      box([
        text("Header"),
        text("Content")
      ])
    ])
  end
end
