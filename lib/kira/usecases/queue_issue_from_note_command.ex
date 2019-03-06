defmodule Kira.Usecases.QueueIssueFromNote do
  @moduledoc """
  We really want to queue issue to be taken later by free developers.
  """

  # TODO: create a custom macros to add .feature file to @moduledoc

  use Exop.Chain

  operation(Kira.Projects.Services.NoteCommands.QueueIssue)
  operation(Kira.Projects.Commands.QueueIssue)
  operation(Kira.Projects.Services.Reactions.IssueNoteReaction)
end
