defmodule Kira.Projects.Services.NoteCommands.QueueIssue do
  @moduledoc """
  Tryies to parse text commands from incoming issue note webhooks.

  In case there are any commands, they are executed.
  Otherwise we use `:idempotence` atom to interupt the future execution.
  """

  use Exop.Operation

  parameter(:note_text, type: :string)

  def process(%{note_text: note_text} = params) do
    # TODO: this is a pretty dump implementation of this command
    # it is required to refactor it
    "\@kira-bot\s+queue"
    |> Regex.compile!()
    |> Regex.run(note_text)
    |> maybe_interupt()

    params
  end

  defp maybe_interupt(match) do
    unless match, do: interrupt(:idempotence)
  end
end
